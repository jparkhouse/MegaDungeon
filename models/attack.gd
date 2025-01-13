extends Resource

class_name Attack

var speed: int
var damage: int

func _init(attack_speed = 5, attack_damage = 1):
	self.speed = attack_speed
	self.damage = attack_damage
	
