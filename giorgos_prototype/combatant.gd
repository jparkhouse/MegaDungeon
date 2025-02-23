@tool
extends Node
class_name Combatant

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")
@export var move_range := 2


@export var character_name: String

@export var max_health: int
var health: int = max_health


@export var actions: Array[ActionClass]

@onready var _sprite = $GenericCombatant/PathFollow2D/Sprite
@onready var _anim_player = $GenericCombatant/AnimationPlayer
@onready var _path_follow: PathFollow2D = $GenericCombatant/PathFollow2D
@onready var _generic_combatant = $GenericCombatant

@export var skin: Texture :
	set(value):
		skin = value
		if not _sprite:
			await self.ready
		_sprite.texture = value
	get:
		return _sprite.texture

@export var corpse_skin: Texture
@export var act_skin: Texture
@export var hurt_skin: Texture

@export var skin_offset := Vector2.ZERO :
	set(value):
		skin_offset = value
		if not _sprite:
			await self.ready
		_sprite.position = value
	get:
		return _sprite.position
		
@export var move_speed := 600.0

var corpse_scene = preload("res://giorgos_prototype/map_objects/obstacle.tscn")

var cell := Vector2.ZERO :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell

var is_selected := false :
	set(value):
		is_selected = value
		if is_selected:
			_anim_player.play("selected")
		else:
			_anim_player.play("idle")
	get:
		return is_selected

var _is_walking := false :
	set(value):
		_is_walking = value
		set_process(_is_walking)
	get:
		return _is_walking



var next_turn
var queued_action
var queued_action_parameters
signal acted
signal walk_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	health = max_health
	# self.cell = grid.calculate_grid_coordinates(_generic_combatant.position)
	_generic_combatant.position = grid.calculate_map_position(cell)
	
	if not Engine.is_editor_hint():
		_generic_combatant.curve = Curve2D.new()
	
	next_turn = 0
	queued_action = null

func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta
	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		_generic_combatant.position = grid.calculate_map_position(cell)
		_generic_combatant.curve.clear_points()
		emit_signal("walk_finished")

func walk_along(path: PackedVector2Array) -> void:
		# there is no path.empty() value
		# so we use not path.size() instead
	if not path.size():
		return
	
	_generic_combatant.curve.add_point(Vector2.ZERO)
	for point in path:
		_generic_combatant.curve.add_point(grid.calculate_map_position(point) - _generic_combatant.position)
		
	cell = path[-1]
	self._is_walking = true
		

func move_to(end_cell):
	var move_line = grid.calculate_line(cell, end_cell)
	move_line.reverse()
	for c in move_line:
		if c not in get_parent().units:
			print(character_name + " is Moving to " + str(c))
			walk_along([c])
			break

func execute_action() -> void:
	if queued_action != null:
		actions[queued_action].perform_action(self, queued_action_parameters)
	queued_action = null

func queue_action(action_nr) -> void:
	next_turn += actions[action_nr].action_time
	queued_action = action_nr
	queued_action_parameters = await actions[queued_action].get_parameters(self)
	emit_signal("acted", actions[action_nr].action_time)

func take_damage(d):
	var normal_skin = skin
	skin = hurt_skin
	await get_tree().create_timer(1).timeout
	skin = normal_skin
	health = health - d
	print(character_name + "'s health is now " + str(health))
	if health <= 0:
		die()

func heal(d):
	health = health + d
	if health > max_health:
		health = max_health

func die():
	var corpse = corpse_scene.instantiate()
	corpse.texture = corpse_skin
	corpse.cell = cell
	corpse.scale = Vector2(0.40, 0.40)
	get_parent().add_child(corpse)
	queue_free()

func cancel_action():
	for node in get_tree().get_nodes_in_group("cursor"):
		if node in get_children():
			print("found cursor")
			node.queue_free()
			
