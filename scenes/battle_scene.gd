extends Node

var current_time: int
var current_character : Character

@export var grid: Resource = preload("res://resources/square_grid.tres")

signal time_passed

@export var green_char_scene := preload("res://scenes/entities/combatants/green_character.tscn")
@export var red_char_scene := preload("res://scenes/entities/combatants/red_character.tscn")

func _ready() -> void:
	grid.offset = $TileMapLayer.position
	current_time = 0
	
	## initialise characters
	var green_char = green_char_scene.instantiate()
	green_char.cell = Vector2(4, 5)
	$GameBoard.add_child(green_char)
	var red_char = red_char_scene.instantiate()
	red_char.cell = Vector2(2, 1)
	$GameBoard.add_child(red_char)
	
	$GameBoard.reinitialize()
	
	for character in get_tree().get_nodes_in_group("character"):
		$HUD.add_character_action_timeline(character)
		print(character.name)
	perform_actions()

func perform_actions() -> void:
	$GameBoard.reinitialize()
	$HUD.clear_buttons()
	for character in get_tree().get_nodes_in_group("character"):
		if current_time == character.next_turn:
			current_character = character
			await current_character.execute_action()
			print(character.character_name + "'s turn")
			current_character.make_selected(true)
			for action in character.actions:
				$HUD.add_action(action)
			$HUD/BottomPanel/HBoxContainer/CharacterName.text = character.character_name
			$HUD/BottomPanel/HBoxContainer/CharacterName.show()
			$HUD/ActionTimelineVbox.get_node(current_character.character_name).make_active()
			return
	advance_time()
	await get_tree().create_timer(0.3).timeout
	await perform_actions()

func advance_time() -> void:
	current_time += 1
	emit_signal("time_passed")

func _on_hud_action(ac_nr : int) -> void:
	await current_character.cancel_action()
	await current_character.queue_action(ac_nr)
	await get_tree().create_timer(0.3).timeout
	current_character.make_selected(false)
	perform_actions()
