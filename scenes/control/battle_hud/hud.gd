extends CanvasLayer
signal action
@export var action_timeline_scene: PackedScene = preload("res://scenes/control/battle_hud/action_timeline.tscn")
@export var action_button_scene:   PackedScene = preload("res://scenes/control/battle_hud/action_button.tscn")

@onready var _character_name := $BottomPanel/HBoxContainer/CharacterName
@onready var _action_timeline_vbox := $ActionTimelineVbox
@onready var _bottom_hbox_container := $BottomPanel/HBoxContainer

var character_action_timelines := {}

var actions := []

func _on_action_pressed(action_key : int) -> void:
	action.emit(action_key)
	
func clear_buttons() -> void:
	actions = []
	for button in get_tree().get_nodes_in_group("action_button"):
		button.queue_free()

func add_character_name(text : String) -> void:
	_character_name.text = text

func add_action(action : ActionClass) -> void:
	actions.append(action)
	add_button(action.action_name, len(actions)-1)

func add_button(text : String, action_key : int) -> void:
	var button = action_button_scene.instantiate()
	button.action_key = action_key
	button.text = text
	_bottom_hbox_container.add_child(button)
	button.connect("action_button_pressed", _on_action_pressed)
	button.show()

func change_active_character(character) -> void:
	_character_name.text = character.character_name
	_character_name.show()
	_action_timeline_vbox.get_node(character.character_name).make_active()

func add_character_action_timeline(char : Character):
	var action_timeline : ActionTimeline = action_timeline_scene.instantiate()
	action_timeline.name = char.character_name
	char.acted.connect(Callable(action_timeline, "_on_character_acted"))
	get_parent().time_passed.connect(Callable(action_timeline, "advance_time"))
	character_action_timelines[char.character_name] = action_timeline
	_action_timeline_vbox.add_child(character_action_timelines[char.character_name])
	action_timeline.add_name(char.character_name)

func clear_character_action_timeline(char : Character):
	character_action_timelines[char.character_name].queue_free()
	character_action_timelines.erase(char.character_name)

func clear_all_character_action_timelines():
	for each in character_action_timelines:
		character_action_timelines[each].queue_free()
	character_action_timelines = {}
