class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")

var _units := {}

func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

func _ready() -> void:
	_reinitialize()


func _reinitialize() -> void:
	_units.clear()
	for character in get_tree().get_nodes_in_group("characters"):
		_units[character.cell] = character
