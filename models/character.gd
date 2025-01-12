extends Resource

class_name Character

var name: String
var attack: Attack
var state: CharacterAction
var state_time_remaining: int
var max_health: int
var curr_health: int

func _init(char_name: String, char_max_health: int):
	self.name = char_name
	self.max_health = char_max_health
	self.curr_health = char_max_health
	self.state = CharacterAction.new()
	self.attack = Attack.new()
	
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
	
'''
Exposes set state function from CharacterAction
'''
func set_state(action_type: CharacterAction.CharacterActionType, duration: int) -> CharacterAction.CharacterActionError:
	return self.state.change_action(action_type, duration)

'''
Checks if the character needs a new action and returns true;
If not, passes one second, then checks again and returns true;
or if there is still more time on the current action returns false.
'''
func pass_second_and_check_action_refresh() -> bool:
	# if the action is already completed, we can just return true
	if self.state.get_time_remaining() <= 0:
		return true
	
	# otherwise we can progress by one second,
	# and then check if the action is completed
	self.state.progress_second()
	if self.state.get_time_remaining() <= 0:
		return true
	else: return false
