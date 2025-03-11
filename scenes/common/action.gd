extends Resource

class_name ActionClass

@export var action_name = ""
@export var action_time: int
var cursor_scene = preload("res://scenes/control/cursor.tscn")

func perform_action(character: Character, parameters: Dictionary) -> void:
	pass
	
func get_parameters(character: Character) -> Dictionary:
	var parameters = {}
	return parameters
