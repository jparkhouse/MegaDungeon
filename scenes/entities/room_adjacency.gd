extends Node
class_name RoomAdjacency

@export var data: RoomAdjacencyData

@onready var target_room := data.target_room
@onready var target_cell := data.target_cell
@onready var cell := data.cell

signal switch_room

func _ready():
	var battle_scene = get_node("/root/BattleScene")
	connect("switch_room", battle_scene.go_to_room)

func export_data() -> RoomAdjacencyData:
	data.cell = cell
	data.target_cell = target_cell
	data.target_room = target_room
	return(data)
	
func on_select() -> void:
	emit_signal("switch_room", target_room)
