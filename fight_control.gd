extends Control

var characters: Array[Character]
var time_passed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	# we need to initialise some characters
	characters = []
	for i in range(5):
		var next_character = Character.new("Character {0}".format(i), 10)
		characters.push_back(next_character)
	
	# and then lets give them some arbitrary states
	# Character 0 can be chillin (defaults to idle)
	# Character 1 is defending
	characters[1].set_state(CharacterAction.CharacterActionType.Defending, 10)
	# Character 2 is running away like a little pussy
	characters[2].set_state(CharacterAction.CharacterActionType.Moving, 2)
	# Character 3 is being a wimp in the corner
	characters[3].set_state(CharacterAction.CharacterActionType.Hiding, 15)
	# Character 4 should have been more of a wimp
	characters[4].die()
	
	# any other setup?
	time_passed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check if time has passed
	time_passed += delta
	if time_passed >= 1:
		time_passed -= 1
		for char in characters:
			var needs_new_action = char.pass_second_and_check_action_refresh()
			if needs_new_action:
				print("{0} needs a new action!".format(char.name))
				print("but right now that is impossible so rocks fall")
				char.die()
			else:
				print("{0} continues action {1}".format(char.name, char.get_current_action().to_string()))
	
	# we also need to update the visuals?
	
