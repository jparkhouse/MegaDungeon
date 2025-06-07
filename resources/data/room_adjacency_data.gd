extends Entity
class_name RoomAdjacencyData

@export var target_room := preload("res://resources/rooms/room_square.tres")
@export var target_cell := Vector2.ZERO

var scene := preload("res://scenes/entities/room_adjacency.tscn")
