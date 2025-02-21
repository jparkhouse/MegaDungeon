extends Sprite2D

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")
var character_name = "obstacle"

var cell := Vector2.ZERO :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell

func _ready() -> void:
	position = grid.calculate_map_position(cell)
	
func take_damage(damage):
	queue_free()
