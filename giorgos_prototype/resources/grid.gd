class_name Grid
extends Resource

@export var size := Vector2(3,3)
@export var cell_size := Vector2(40,40)
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

func calculate_distance(cell_1, cell_2):
	return roundf(sqrt((cell_1.x-cell_2.x)**2+(cell_1.y-cell_2.y)**2))

func calculate_line_H(start_cell, end_cell):
	var line_points = []
	
	var x_0 = start_cell.x
	var x_1 = end_cell.x
	var y_0 = start_cell.y
	var y_1 = end_cell.y
	var reverse = false
	
	if x_0 > x_1:
		reverse = true
		var t = x_0
		x_0 = x_1
		x_1 = t
		t = y_0
		y_0 = y_1
		y_1 = t
		
	var dx = x_1 - x_0
	var dy = y_1 - y_0
	
	var dir = -1 if dy <0 else 1
	dy *= dir
	
	if dx != 0:
		var y = y_0
		var p = 2*dy - dx
		for i in range(dx+1):
			line_points.append(Vector2(x_0+i, y))
			if p >= 0:
				y += dir
				p = p-2*dx
			p = p+2*dy
	
	if reverse:
		line_points.reverse()
	return line_points

func calculate_line_V(start_cell, end_cell):
	var line_points = []
	
	var x_0 = start_cell.x
	var x_1 = end_cell.x
	var y_0 = start_cell.y
	var y_1 = end_cell.y
	var reverse = false
	
	if y_0 > y_1:
		reverse = true
		var t = x_0
		x_0 = x_1
		x_1 = t
		t = y_0
		y_0 = y_1
		y_1 = t
		
	var dx = x_1 - x_0
	var dy = y_1 - y_0
	
	var dir = -1 if dx <0 else 1
	dx *= dir
	
	if dy != 0:
		var x = x_0
		var p = 2*dx - dy
		for i in range(dy+1):
			line_points.append(Vector2(x, y_0+i))
			if p >= 0:
				x += dir
				p = p-2*dy
			p = p+2*dx
	
	if reverse:
		line_points.reverse()
	return line_points

func calculate_line(start_cell, end_cell):
	print(start_cell)
	print(end_cell)
	if abs(end_cell.x-start_cell.x) > abs(end_cell.y-start_cell.y):
		return calculate_line_H(start_cell, end_cell) 
	return calculate_line_V(start_cell, end_cell)
