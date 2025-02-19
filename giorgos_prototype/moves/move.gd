extends Resource

class_name MoveClass

@export var move_name = ""
@export var move_time: int
var cursor_scene = preload("res://giorgos_prototype/cursor.tscn")

func perform_move(character, parameters):
	pass
	
func get_parameters(character):
	var parameters = {}
	return parameters
