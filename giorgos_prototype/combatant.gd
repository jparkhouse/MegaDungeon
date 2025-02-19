@tool
extends Node
class_name Combatant

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")
@export var move_range := 2


@export var character_name: String

@export var health: int


@export var moves: Array[MoveClass]

@onready var _sprite = $GenericCombatant/PathFollow2D/Sprite
@onready var _anim_player = $GenericCombatant/AnimationPlayer
@onready var _path_follow: PathFollow2D = $GenericCombatant/PathFollow2D
@onready var _generic_combatant = $GenericCombatant

@export var skin: Texture :
	set(value):
		skin = value
		if not _sprite:
						# yield has been replaced with await
						# and we await the value on the self object
			await self.ready
		_sprite.texture = value
	get:
		return _sprite.texture

@export var skin_offset := Vector2.ZERO :
	set(value):
		skin_offset = value
		if not _sprite:
			await self.ready
		_sprite.position = value
	get:
		return _sprite.position
		
@export var move_speed := 600.0

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
signal moved
signal walk_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
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
		

func execute_move() -> void:
	if queued_action != null:
		moves[queued_action].perform_move(self, queued_action_parameters)
	queued_action = null

func queue_move(move_nr) -> void:
	next_turn += moves[move_nr].move_time
	queued_action = move_nr
	queued_action_parameters = await moves[queued_action].get_parameters(self)
	emit_signal("moved", moves[move_nr].move_time)

func add_move_times():
	pass

func take_damage(d):
	health = health - d
	print(character_name + "'s health is now " + str(health))

func heal(d):
	health = health + d
