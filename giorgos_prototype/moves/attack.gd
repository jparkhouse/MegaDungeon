extends MoveClass

class_name AttackClass

@export var damage:    int

func perform_move(character):
	print(character.character_name + " is attacking for " + str(damage) + " damage")
