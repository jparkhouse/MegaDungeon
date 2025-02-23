extends ActionClass

class_name AoeAttackClass

@export var damage:    int
@export var range := 2
@export var cells : Array[Vector2] = [Vector2(0,0)]

func perform_action(character, parameters):
	var normal_skin = character.skin
	character.skin = character.act_skin
	await character.get_tree().create_timer(1).timeout
	character.skin = normal_skin
	for c in cells:
		if parameters["cell"]+c in character.get_parent().units:
			character.get_parent().units[parameters["cell"]+c].take_damage(damage)
			print(character.get_parent().units[parameters["cell"]+c].character_name + " took " + str(damage) + " damage")
	

func get_parameters(character):
	var parameters = {}
	var cursor = cursor_scene.instantiate()
	cursor.cells = cells
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	cursor.queue_free()
	return parameters
