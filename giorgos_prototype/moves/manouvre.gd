extends MoveClass

class_name ManouvreClass

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")

func perform_move(character, parameters):
	print(character.character_name + " is Moving to " + str(parameters["cell"]))
	character.walk_along([parameters["cell"]])
	
func get_parameters(character):
	var parameters = {}
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	
	var valid_selection = false
	while not valid_selection:
		parameters["cell"] = await cursor.accept_pressed
		if grid.calculate_distance(parameters["cell"], character.cell) <= character.move_range:
			valid_selection = true
		else:
			print("too far")
	print(parameters["cell"])
	cursor.queue_free()
	return parameters
