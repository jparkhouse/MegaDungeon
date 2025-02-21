extends MoveClass

class_name MoveAttackClass

@export var damage:    int
@export var range := 1
@export var move_range := 1

func perform_move(character, parameters):
	var line_cells = character.grid.calculate_line(character.cell, parameters["target"].cell)
	if len(line_cells) - 1 > move_range:
		character.walk_along([line_cells[move_range]])
	else:
		character.walk_along([line_cells[-2]])
	var distance = character.grid.calculate_distance(character.cell, parameters["target"].cell)
	if distance > range:
		print(character.character_name + " failed to attack due to distance")
	else:
		print(character.character_name + " is attacking for " + str(damage) + " damage")
		parameters["target"].take_damage(damage)
	

func get_parameters(character):
	var parameters = {}
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	parameters["target"] = character.get_parent().units[parameters["cell"]]
	cursor.queue_free()
	return parameters
