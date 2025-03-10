extends ActionClass

class_name AttackClass

@export var damage:    int
@export var range := 1

func perform_action(character, parameters):
	var distance = character.grid.calculate_distance(character.cell, parameters["target"].cell)
	if distance > range:
		print(character.character_name + " failed to attack due to distance")
	else:
		print(character.character_name + " is attacking for " + str(damage) + " damage")
		parameters["target"].take_damage(damage)
	
	character.play_animation("attack")

func get_parameters(character):
	var parameters = {}
	var cursor = cursor_scene.instantiate()
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	for entity in character.get_parent().units[parameters["cell"]].values():
		if entity.is_in_group("damagable"):
			parameters["target"] = entity
	cursor.queue_free()
	return parameters
