extends MoveClass

class_name ManouvreClass

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")

func perform_move(character, parameters):
	print(character.character_name + " is Moving to " + str(parameters["cell"]))
	character.walk_along([parameters["cell"]])
	
func get_parameters(character):
	var parameters = {}
	print("Getting parameters")
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	print(parameters["cell"])
	cursor.queue_free()
	return parameters
