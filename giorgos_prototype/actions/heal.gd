extends ActionClass

class_name HealClass

@export var damage:    int

func perform_action(character, parameters):
	var normal_skin = character.skin
	character.skin = character.act_skin
	await character.get_tree().create_timer(1).timeout
	character.skin = normal_skin
	print(character.character_name + " is healing for " + str(damage))
	character.heal(damage)
