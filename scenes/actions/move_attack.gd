extends ActionClass

class_name MoveAttackClass

@export var damage:    int
@export var range := 1:
	set(value):
		range = value
		total_range = range + move_range
	get:
		return range
@export var move_range := 1:
	set(value):
		move_range = value
		total_range = range + move_range
	get:
		return move_range
var total_range = range + move_range

func perform_action(character: Character, parameters: Dictionary) -> void:
	var line_cells : Array[Vector2] = character.grid.calculate_line(character.cell, parameters["target"].cell)
	if len(line_cells) - 1 > move_range:
		character.move_to(line_cells[move_range])
	else:
		character.move_to(line_cells[-2])
	var distance : int = character.grid.calculate_distance(character.cell, parameters["target"].cell)
	if distance > range:
		print(character.character_name + " failed to attack due to distance")
	else:
		print(character.character_name + " is attacking for " + str(damage) + " damage")
		parameters["target"].take_damage(damage)
	character.play_animation("attack")
	

func get_parameters(character: Character) -> Dictionary:
	var parameters : Dictionary = {}
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	for entity in character.get_parent().units[parameters["cell"]]:
		if entity.is_in_group("damagable"):
			parameters["target"] = entity
	cursor.queue_free()
	return parameters
