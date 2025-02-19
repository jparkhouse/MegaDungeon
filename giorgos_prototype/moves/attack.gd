extends MoveClass

class_name AttackClass

@export var damage:    int

func perform_move(character, parameters):
	print(character.character_name + " is attacking for " + str(damage) + " damage")

func get_parameters(character):
	var parameters = {}
	print("Getting parameters")
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	print(parameters["cell"])
	print(character.get_parent().units)
	print(character.get_parent().units[parameters["cell"]])
	cursor.queue_free()
	return parameters
