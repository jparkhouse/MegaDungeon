extends Node
class_name Combatant

@export var character_name: String

@export var health: int


@export var moves: Array[MoveClass]

var next_turn
var queued_action
signal moved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_turn = 0
	queued_action = null

func execute_move() -> void:
	if queued_action != null:
		moves[queued_action].perform_move(self)
	queued_action = null

func queue_move(move_nr) -> void:
	next_turn += moves[move_nr].move_time
	queued_action = move_nr
	emit_signal("moved", moves[move_nr].move_time)

func add_move_times():
	pass
