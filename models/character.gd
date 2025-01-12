extends Resource

class_name Character

var name: String
var attack: Attack
var state: CharacterAction
var state_time_remaining: int
var max_health: int
var curr_health: int

func _init(name: String, max_health: int):
	self.name = name
	self.max_health = max_health
	self.curr_health = max_health
	self.state = CharacterAction.new()
	
	
'''
Applies some amount of damage to the character
'''
func apply_damage(amount: int):
	self.curr_health -= amount
	if self.curr_health <= 0:
		die()

'''
Kills the character
'''
func die():
	self.curr_health = 0
	self.state.die()

'''
Returns the current action and how long is remaining
'''
func get_current_action() -> CharacterAction:
	return self.state

