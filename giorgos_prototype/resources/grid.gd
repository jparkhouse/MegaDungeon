class_name Grid
extends Resource

@export var size := Vector2(3,3)
@export var cell_size := Vector2(80,80)
@export var offset := Vector2(0,0)

var _half_cell_size = cell_size/2

func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size + offset


func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return ((map_position - offset) / cell_size).floor()

func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var inside_x := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	var inside_y := cell_coordinates.y >= 0 and cell_coordinates.y < size.y
	return inside_x and inside_y

func gridclamp(grid_position: Vector2) -> Vector2:
	var clamped_position := grid_position
	clamped_position.x = clamp(clamped_position.x, 0, size.x - 1.0)
	clamped_position.y = clamp(clamped_position.y, 0, size.y - 1.0)
	return clamped_position
	
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
	
func from_index(cell: int) -> Vector2:
	return Vector2(cell % int(size.x), cell / int(size.x))
