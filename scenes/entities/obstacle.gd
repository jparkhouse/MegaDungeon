extends Node

@export var grid: Resource = preload("res://resources/square_grid.tres")

var character_name := "obstacle"
@onready var _sprite := $Sprite
@export var data: ObstacleData

@onready var skin: Texture = data.skin
@onready var cell := data.cell :
	set(value):
		cell = value
		_sprite.position = grid.calculate_map_position(value)
	get:
		return cell
@onready var hframes : int = data.hframes
@onready var vframes : int = data.vframes
@onready var frame : int = data.frame
@onready var scale : Vector2 = data.scale

func _ready() -> void:
	set_skin(skin)
	set_cell(cell)
	set_skin_frame(hframes, vframes, frame)
	set_scale(scale)

func take_damage(damage : int) -> void:
	queue_free()

func set_cell(new_cell : Vector2):
	cell = new_cell
	print(_sprite.position)

func set_skin(new_skin: Texture):
	skin = new_skin
	_sprite.texture = new_skin

func set_scale(scale: Vector2):
	_sprite.scale = scale

func set_skin_frame(h:int, v:int, fr:int):
	_sprite.hframes = h
	_sprite.vframes = v
	_sprite.frame = fr
	
func export_data() -> ObstacleData:
	data.skin = skin
	data.cell = cell
	data.hframes = _sprite.hframes
	data.vframes = _sprite.vframes
	data.frame = _sprite.frame
	data.scale = _sprite.scale
	return(data)
