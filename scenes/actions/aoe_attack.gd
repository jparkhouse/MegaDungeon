extends ActionClass

class_name AoeAttackClass

@export var damage:    int
@export var range := 2
@export var cells : Array[Vector2] = [Vector2(0,0)]

func perform_action(character: Character, parameters: Dictionary) -> void:
	await character.play_animation("attack")
	for c in cells:
		for entity in character.get_parent().units[parameters["cell"]+c]:
			if entity.is_in_group("damagable"):
				entity.take_damage(damage)
				print(entity.character_name + " took " + str(damage) + " damage")
	
	
func get_parameters(character: Character) -> Dictionary:
	var parameters : Dictionary = {}
	var cursor : Cursor = cursor_scene.instantiate()
	cursor.cells = cells
	character.add_child(cursor)
	parameters["cell"] = await cursor.accept_pressed
	cursor.queue_free()
	return parameters
