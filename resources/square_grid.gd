class_name SquareGrid
extends Resource


@export var size := Vector2(3,3)
@export var cell_size := Vector2(40,40)
@export var offset := Vector2(0,0)

var _half_cell_size = cell_size/2

func calculate_map_position(grid_coordinates: Vector2) -> Vector2:
	## takes in the coordinates in grid space
	## returns the position of the centre of the square on the global coordinate system 
	return grid_coordinates * cell_size + _half_cell_size + offset

func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	## takes in a position on the global coordinate system
	## returns the coordinates in grid space of square this position is in
	return ((map_position - offset) / cell_size).floor()
	
func is_within_bounds(grid_coordinates: Vector2) -> bool:
	## takes in the coordinates in grid space
	## returns true if the square is within bounds and false otherwise
	var inside_x := grid_coordinates.x >= 0 and grid_coordinates.x < size.x
	var inside_y := grid_coordinates.y >= 0 and grid_coordinates.y < size.y
	return inside_x and inside_y
	
func gridclamp(grid_coordinates: Vector2) -> Vector2:
	## takes in the coordinates in grid space
	## returns the same grid coordinates if within bounds
	## returns closest coordinates within bounds otherwise
	var clamped_position := grid_coordinates
	clamped_position.x = clamp(clamped_position.x, 0, size.x - 1.0)
	clamped_position.y = clamp(clamped_position.y, 0, size.y - 1.0)
	return clamped_position
	
func calculate_distance(cell_1, cell_2) -> int:
	## returns the integer distance between two cells, as calculated by pythagorian theorum
	return roundf(sqrt((cell_1.x-cell_2.x)**2 + (cell_1.y-cell_2.y)**2))

func calculate_line(start_cell, end_cell) -> Array[Vector2]:
	## implementation of Bresenham's Line Generation Algorithm
	## takes in a starting point and ending point as coordinates in grid space
	## returns an array of coordinates in grid space for all spaces the line between those two points passes through
	## including the starting and ending points
	## maths according to this video: https://www.youtube.com/watch?v=CceepU1vIKo
	if abs(end_cell.x-start_cell.x) > abs(end_cell.y-start_cell.y):
		return calculate_line_H(start_cell, end_cell) 
	return calculate_line_V(start_cell, end_cell)

func calculate_line_H(start_cell, end_cell) -> Array[Vector2]:
	## horisontal component of the line generation algorithm
	var line_points : Array[Vector2] = []
	
	var x_0 : int = start_cell.x
	var x_1 : int = end_cell.x
	var y_0 : int = start_cell.y
	var y_1 : int = end_cell.y
	var reverse := false
	
	if x_0 > x_1:
		reverse = true
		var t : int = x_0
		x_0 = x_1
		x_1 = t
		t = y_0
		y_0 = y_1
		y_1 = t
		
	var dx : int = x_1 - x_0
	var dy : int = y_1 - y_0
	
	var dir : int = -1 if dy <0 else 1
	dy *= dir
	
	if dx != 0:
		var y : int = y_0
		var p : int = 2*dy - dx
		for i in range(dx+1):
			line_points.append(Vector2(x_0+i, y))
			if p >= 0:
				y += dir
				p = p-2*dx
			p = p+2*dy
	
	if reverse:
		line_points.reverse()
	return line_points

func calculate_line_V(start_cell, end_cell) -> Array[Vector2]:
	## vertical component of the line generation algorithm
	var line_points : Array[Vector2] = []
	
	var x_0 : int = start_cell.x
	var x_1 : int = end_cell.x
	var y_0 : int = start_cell.y
	var y_1 : int = end_cell.y
	var reverse := false
	
	if y_0 > y_1:
		reverse = true
		var t : int = x_0
		x_0 = x_1
		x_1 = t
		t = y_0
		y_0 = y_1
		y_1 = t
		
	var dx : int = x_1 - x_0
	var dy : int = y_1 - y_0
	
	var dir : int = -1 if dx <0 else 1
	dx *= dir
	
	if dy != 0:
		var x : int = x_0
		var p : int = 2*dx - dy
		for i in range(dy+1):
			line_points.append(Vector2(x, y_0+i))
			if p >= 0:
				x += dir
				p = p-2*dy
			p = p+2*dx
	
	if reverse:
		line_points.reverse()
	return line_points
