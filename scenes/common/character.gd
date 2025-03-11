extends Node
class_name Character

@export var grid: Resource = preload("res://resources/square_grid.tres")


var corpse_scene = preload("res://scenes/entities/obstacles/obstacle.tscn")

var next_turn := 0
var queued_action
var queued_action_parameters

@export var skin: Texture :
	set(value):
		skin = value
		if not $Visuals/PathFollow2D/Sprite:
			await self.ready
		$Visuals/PathFollow2D/Sprite.texture = value
	get:
		return $Visuals/PathFollow2D/Sprite.texture
@export var actions: Array[ActionClass]
@export var character_name: String
@export var max_health: int
@export var move_range: int = 2
var health: int = max_health

@export var walk_speed := 600.0

var is_selected := false

signal acted
signal walk_finished

var _is_walking := false :
	set(value):
		_is_walking = value
		set_process(_is_walking)
	get:
		return _is_walking

var cell := Vector2.ZERO :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell

func _ready() -> void:
	set_process(false)
	health = max_health
	$Visuals.position = grid.calculate_map_position(cell)
	$Visuals/AnimationPlayer.play("idle")
	if not Engine.is_editor_hint():
		$Visuals.curve = Curve2D.new()

	queued_action = null

func _process(delta: float) -> void:
	$Visuals/PathFollow2D.progress += walk_speed * delta
	if $Visuals/PathFollow2D.progress_ratio >= 1.0:
		self._is_walking = false
		$Visuals/PathFollow2D.progress = 0.0
		$Visuals.position = grid.calculate_map_position(cell)
		$Visuals.curve.clear_points()
		emit_signal("walk_finished")

func make_selected(selected) -> void:
	is_selected = selected
	if selected:
		if $Visuals/AnimationPlayer.current_animation != "selected" and $Visuals/AnimationPlayer.current_animation != "idle":
			await $Visuals/AnimationPlayer.animation_finished
		$Visuals/AnimationPlayer.play("selected")
	else:
		if $Visuals/AnimationPlayer.current_animation != "selected" and $Visuals/AnimationPlayer.current_animation != "idle":
			await $Visuals/AnimationPlayer.animation_finished
		$Visuals/AnimationPlayer.play("idle")

func walk_along(path: PackedVector2Array) -> void:
	if not path.size():
		return
	
	$Visuals.curve.add_point(Vector2.ZERO)
	for point in path:
		$Visuals.curve.add_point(grid.calculate_map_position(point) - $Visuals.position)
		
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

func queue_action(action_nr : int) -> void:
	next_turn += actions[action_nr].action_time
	queued_action = action_nr
	queued_action_parameters = await actions[queued_action].get_parameters(self)
	emit_signal("acted", actions[action_nr].action_time)

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
	corpse.skin = $Visuals/PathFollow2D/Sprite.texture
	corpse.set_skin_frame($Visuals/PathFollow2D/Sprite.hframes, $Visuals/PathFollow2D/Sprite.vframes, 3)
	corpse.cell = cell
	corpse.scale = Vector2(0.40, 0.40)
	get_parent().add_child(corpse)
	queue_free()

func play_animation(animation : String) -> void:
	var current_animation = $Visuals/AnimationPlayer.current_animation
	$Visuals/AnimationPlayer.play(animation)
	await $Visuals/AnimationPlayer.animation_finished
	$Visuals/AnimationPlayer.play(current_animation)
