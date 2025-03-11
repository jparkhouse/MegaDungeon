extends CanvasLayer
signal action
@export var action_timeline_scene: PackedScene = preload("res://scenes/control/battle_hud/action_timeline.tscn")
@export var action_button_scene:   PackedScene = preload("res://scenes/control/battle_hud/action_button.tscn")

var character_action_timelines := {}

var actions := []

func _on_action_pressed(action_key : int) -> void:
	print("on action pressed")
	action.emit(action_key)
	
func clear_buttons() -> void:
	actions = []
	for button in get_tree().get_nodes_in_group("action_button"):
		button.queue_free()

func add_character_name(text : String) -> void:
	$BottomPanel/HBoxContainer/CharacterName.text = text

func add_action(action : ActionClass) -> void:
	actions.append(action)
	add_button(action.action_name, len(actions)-1)

func add_button(text : String, action_key : int) -> void:
	var button = action_button_scene.instantiate()
	button.action_key = action_key
	button.text = text
	$BottomPanel/HBoxContainer.add_child(button)
	button.connect("action_button_pressed", _on_action_pressed)
	button.show()
	

func add_character_action_timeline(char : Character):
	var action_timeline : ActionTimeline = action_timeline_scene.instantiate()
	action_timeline.add_name(char.character_name)
	action_timeline.name = char.character_name
	char.acted.connect(Callable(action_timeline, "_on_character_acted"))
	get_parent().time_passed.connect(Callable(action_timeline, "advance_time"))
	character_action_timelines[char.character_name] = action_timeline
	$ActionTimelineVbox.add_child(character_action_timelines[char.character_name])
