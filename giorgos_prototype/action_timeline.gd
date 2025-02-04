extends ColorRect
var children_rectangles
var rects_on
@export var on_colour: Color
@export var off_colour: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rects_on = 0
	children_rectangles = [
		$second_1, 
		$second_2, 
		$second_3, 
		$second_4, 
		$second_5, 
		$second_6, 
		$second_7, 
		$second_8, 
		$second_9
		]

func turn_on(n_rects):
	rects_on = n_rects
	for i in range(len(children_rectangles)):
		if i < n_rects:
			children_rectangles[i].color = on_colour
		else:
			children_rectangles[i].color = off_colour
	pass

func make_active():
	$NameLabel.set("theme_override_colors/font_color",on_colour)
	
func make_inactive():
	$NameLabel.set("theme_override_colors/font_color",off_colour)

func add_name(char_name):
	$NameLabel.text = char_name
	
func _on_character_moved(move_time):
	turn_on(move_time)
	make_inactive()

func advance_time():
	rects_on -= 1
	turn_on(rects_on)
