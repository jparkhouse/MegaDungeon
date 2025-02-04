extends Node2D
var move_times
var next_turn 
var character_name
signal moved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_turn = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute_move(move_nr) -> void:
	next_turn += move_times[move_nr]
	emit_signal("moved", move_times[move_nr])

func add_move_times():
	pass
