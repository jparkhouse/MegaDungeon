extends Resource

class_name Character

var name: String
var alive: bool
var attack: Attack
var state: CharacterAction
var state_time_remaining: int
var max_health: int
var curr_health: int

func apply_damage(amount: int):
	self.health -= amount
	if self.health <= 0:
		die()

func die():
	self.alive = false
	self.health = 0
	self.state.die()

func get_current_action() -> CharacterAction:
	return self.state



