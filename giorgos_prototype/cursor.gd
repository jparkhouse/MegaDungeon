@tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal move_new(cell)

@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")
@export var ui_cooldown := 0.1

@onready var _timer: Timer = $Timer

var cell := Vector2.ZERO :
	set(value):
		var new_cell: Vector2 = grid.gridclamp(value)
		if new_cell.is_equal_approx(cell):
			return
		cell = new_cell
		position = grid.calculate_map_position(cell)
		emit_signal("moved", cell)
		_timer.start()
	get:
		return cell


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)

	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		print("CLICKED")
		emit_signal("accept_pressed", cell)

func _draw() -> void:
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
