extends Resource
class_name RoomData

@export var entities: Array[Entity]
@export var room_size : Vector2i = Vector2i(5,5)
@export var ground_atlas : Array[Vector2i]= [Vector2i(9,8), Vector2i(16,10)]
