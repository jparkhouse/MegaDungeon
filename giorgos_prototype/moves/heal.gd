extends MoveClass

class_name HealClass

@export var damage:    int

func perform_move(character, parameters):
	print(character.character_name + " is healing for " + str(damage))
	character.heal(damage)
