class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")

var units := {}

func is_occupied(cell: Vector2) -> bool:
	return true if units.has(cell) else false

func _ready() -> void:
	reinitialize()


func reinitialize() -> void:
	units.clear()
	for entity in get_tree().get_nodes_in_group("map_entity"):
		units[entity.cell] = entity
		
