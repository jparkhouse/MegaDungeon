extends Node
class_name Character

@export var grid: Resource = preload("res://resources/square_grid.tres")
@export var data: CharacterData

@export var walk_speed := 600.0
var corpse_scene = preload("res://scenes/entities/obstacle.tscn")
var corpse_data = preload("res://resources/obstacles/generic_obstacle.tres")

var next_turn := 0
var queued_action
var queued_action_parameters

@onready var _sprite := $Visuals/PathFollow2D/Sprite
@onready var _visuals := $Visuals
@onready var _anim_player := $Visuals/AnimationPlayer
@onready var _path_follow := $Visuals/PathFollow2D

@onready var character_name: String = data.character_name
@onready var skin: Texture = data.skin:
	set(value):
		skin = value
		_sprite.texture = value
	get:
		return _sprite.texture
@onready var actions: Array[ActionClass] = data.actions
@onready var max_health: int = data.max_health
@onready var move_range: int = data.move_range
@onready var health: int = data.health


@onready var cell : Vector2 = grid.gridclamp(data.cell) :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell
		

var is_selected := false

signal acted
signal walk_finished

var _is_walking := false :
	set(value):
		_is_walking = value
		set_process(_is_walking)
	get:
		return _is_walking


func _ready() -> void:
	skin = data.skin
	set_process(false)
	health = max_health
	_visuals.position = grid.calculate_map_position(cell)
	_anim_player.play("idle")
	if not Engine.is_editor_hint():
		_visuals.curve = Curve2D.new()

	queued_action = null

func _process(delta: float) -> void:
	_path_follow.progress += walk_speed * delta
	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		_visuals.position = grid.calculate_map_position(cell)
		_visuals.curve.clear_points()
		emit_signal("walk_finished")

func make_selected(selected) -> void:
	is_selected = selected
	if selected:
		if _anim_player.current_animation != "selected" and _anim_player.current_animation != "idle":
			await _anim_player.animation_finished
		_anim_player.play("selected")
	else:
		if _anim_player.current_animation != "selected" and _anim_player.current_animation != "idle":
			await _anim_player.animation_finished
		_anim_player.play("idle")

func walk_along(path: PackedVector2Array) -> void:
	if not path.size():
		return
	
	_visuals.curve.add_point(Vector2.ZERO)
	for point in path:
		_visuals.curve.add_point(grid.calculate_map_position(point) - _visuals.position)
		
	cell = path[-1]
	self._is_walking = true

func move_to(end_cell : Vector2) -> void:
	var move_line = grid.calculate_line(cell, end_cell)
	move_line.reverse()
	for c in move_line:
		var cell_available = true
		for u in get_parent().units[c]:
			if u.is_in_group("obstacle"):
				cell_available = false
		if cell_available:
			walk_along([c])
			break

func execute_action() -> void:
	if queued_action != null:
		await actions[queued_action].perform_action(self, queued_action_parameters)
	queued_action = null

func queue_action(action_index : int) -> void:
	next_turn += actions[action_index].action_time
	queued_action = action_index
	queued_action_parameters = await actions[queued_action].get_parameters(self)
	emit_signal("acted", actions[action_index].action_time)

func cancel_action() -> void:
	for node in get_tree().get_nodes_in_group("cursor"):
		if node in get_children():
			node.queue_free()

func take_damage(d : int) -> void:
	play_animation("damage")
	health = health - d
	print(character_name + "'s health is now " + str(health))
	if health <= 0:
		die()

func heal(d : int) -> void:
	health = health + d
	if health > max_health:
		health = max_health

func die() -> void:
	var corpse = corpse_scene.instantiate()
	corpse.data = corpse_data
	get_parent().add_child(corpse)
	corpse.set_skin(_sprite.texture)
	corpse.set_skin_frame(_sprite.hframes, _sprite.vframes, 3)
	print("in die")
	corpse.set_cell(cell)
	corpse.set_scale(Vector2(0.40, 0.40))
	queue_free()

func play_animation(animation : String) -> void:
	var current_animation = _anim_player.current_animation
	_anim_player.play(animation)
	await _anim_player.animation_finished
	_anim_player.play(current_animation)

func export_data() -> CharacterData:
	data.character_name = character_name
	data.skin = skin
	data.actions = actions
	data.max_health = max_health
	data.move_range = move_range
	data.health = health
	data.cell = cell
	return(data)
