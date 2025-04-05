class_name GameBoard
extends TileMapLayer

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
@export var grid: Resource = preload("res://resources/square_grid.tres")
@export var data: RoomData

@onready var entities: Array[Entity] = data.entities
@onready var room_size : Vector2i = data.room_size
@onready var ground_atlas : Array[Vector2i] = data.ground_atlas

var units := {}

func is_occupied(cell: Vector2) -> bool:
	return true if units.has(cell) else false

func _ready() -> void:
	grid.offset = position
	grid.size = room_size
	for entity in entities:
		var en_scene = entity.scene.instantiate()
		en_scene.data = entity
		add_child(en_scene)
	reinitialize()
 
func reinitialize() -> void:
	for cell_x in range(room_size.x):
		for cell_y in range(room_size.y):
			set_cell(Vector2(cell_x,cell_y),0,ground_atlas[(cell_x+cell_y)%2])
	units.clear()
	for x in range(grid.size.x):
		for y in range(grid.size.y):
			units[Vector2(x,y)] = []
	for entity in get_tree().get_nodes_in_group("map_entity"):
		units[entity.cell].append(entity)

func export_data() -> RoomData:
	var new_entities : Array[Entity] = []
	for entity in get_tree().get_nodes_in_group("map_entity"):
		new_entities.append(entity.export_data())
	data.entities = new_entities
	return(data)
