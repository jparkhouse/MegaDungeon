extends Node

var current_time: int
var current_character : Character

@export var grid: Resource = preload("res://resources/square_grid.tres")

signal time_passed


@onready var _tile_map_layer := $GameBoard/TileMapLayer
@onready var _hud := $HUD

var game_board : GameBoard
var current_room := 0
var room_scene : PackedScene = preload("res://scenes/room.tscn")
var rooms_data := [
	preload("res://resources/rooms/room_square.tres"),
	preload("res://resources/rooms/room_long.tres")
]

func _ready() -> void:
	init_room(current_room)

func init_room(room_id:int) -> void:
	game_board = room_scene.instantiate()
	game_board.data = rooms_data[room_id]
	add_child(game_board)
	current_time = 0
	start_battle()

func next_room() -> void:
	rooms_data[current_room] = game_board.export_data()
	current_room = (current_room+1)%len(rooms_data)
	game_board.queue_free()
	_hud.clear_all_character_action_timelines()
	await get_tree().process_frame
	init_room(current_room)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar"):
		next_room()

func start_battle() -> void:
	game_board.reinitialize()
	
	for character in get_tree().get_nodes_in_group("character"):
		_hud.add_character_action_timeline(character)
	perform_actions()
	
func perform_actions() -> void:
	game_board.reinitialize()
	_hud.clear_buttons()
	for character in get_tree().get_nodes_in_group("character"):
		if current_time == character.next_turn:
			current_character = character
			await current_character.execute_action()
			print(character.character_name + "'s turn")
			current_character.make_selected(true)
			for action in character.actions:
				_hud.add_action(action)
			_hud.change_active_character(current_character)
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
