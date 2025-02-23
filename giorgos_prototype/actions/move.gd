extends Resource

class_name ActionClass

@export var action_name = ""
@export var action_time: int
var cursor_scene = preload("res://giorgos_prototype/cursor.tscn")

func perform_action(character, parameters):
	pass
	
func get_parameters(character):
	var parameters = {}
	return parameters
