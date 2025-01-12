extends Resource

class_name CharacterAction

'''Used to represent the types of actions a character can do'''
enum CharacterActionType {
	Idle,
	Attacking,
	Moving,
	Hiding,
	Defending,
	Dead,
}

'''
An Error type for CharacterAction functions.
Use Success for all cases where an operation succeeds
Use a descriptive member for any case that does not succeed
'''
enum CharacterActionError {
	Success,
	CurrentlyBusy,
	Dead
}

var action_type: CharacterActionType
var time_remaining: int

func _init():
	# start by doing nothing
	self.action_type = CharacterActionType.Idle
	self.time_remaining = 0

'''
Can be used to cancel an action in progress, not intending to escape
debugging/developer use.
'''
func _cancel():
	self.action_type = CharacterActionType.Idle
	self.time_remaining = 0

'''Gets the time left on the current action'''
func get_time_remaining() -> int:
	return self.time_remaining

'''
Used to change the action. Checks that the character is not dead,
and has finished its previous action, and if so, updates and returns success
Otherwise, returns Dead for a dead character or CurrentlyBusy for a character
with an ongoing action
'''
func change_action(type: CharacterActionType, time: int) -> CharacterActionError:
	if self.action_type == CharacterActionType.Dead:
		return CharacterActionError.Dead
	if self.time_remaining == 0:
		self.action_type = type
		self.time_remaining = time
		return CharacterActionError.Success
	return CharacterActionError.CurrentlyBusy

func die():
	self.action_type = CharacterActionType.Dead
	self.time_remaining = INF

func progress_second(amount = 1):
	self.time_remaining -= amount
