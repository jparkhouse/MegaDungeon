@tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal move_new(cell)

@export var grid: Resource = preload("res://resources/square_grid.tres")
@export var ui_cooldown := 0.1

var active = false

@export var cells := [Vector2(0,0)]

var cell := Vector2.ZERO :
	set(value):
		var new_cell: Vector2 = grid.gridclamp(value)
		new_cell = value
		if new_cell.is_equal_approx(cell):
			return
		active = false
		for c in cells:
			if value + c == grid.gridclamp(value + c):
				show()
				active = true
				cell = new_cell
				position = grid.calculate_map_position(cell)
				emit_signal("moved", cell)
		if not active:
			active = false
			hide()
		$Timer.start()
	get:
		return cell


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	$Timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)

	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		if active:
			emit_signal("accept_pressed", cell)

func _draw() -> void:
	for c in cells:
		draw_rect(Rect2(-grid.cell_size/2 + grid.cell_size*c, grid.cell_size), Color.ALICE_BLUE, false, 2.0)
