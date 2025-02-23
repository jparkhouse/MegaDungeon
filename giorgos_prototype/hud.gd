extends CanvasLayer
signal action
@export var action_timeline_scene: PackedScene
var character_action_timelines = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_action_1_pressed() -> void:
	action.emit(0)


func _on_action_2_pressed() -> void:
	action.emit(1)


func _on_action_3_pressed() -> void:
	action.emit(2)

func add_character_action_timeline(char):
	var cat = action_timeline_scene.instantiate()
	cat.add_name(char.character_name)
	cat.name = char.character_name
	char.acted.connect(Callable(cat, "_on_character_moved"))
	character_action_timelines[char.character_name] = cat
	$ActionTimelineVbox.add_child(character_action_timelines[char.character_name])
