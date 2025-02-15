extends Node
@export var red_char_scene: PackedScene
@export var blue_char_scene: PackedScene
var current_time: int
var current_character


@export var grid: Resource = preload("res://giorgos_prototype/resources/grid.tres")

signal time_passed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.offset = $TileMapLayer.position
	current_time = 0
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 6)
	
	var char_1 = red_char_scene.instantiate()
	char_1.cell = Vector2(2, 2)
	$HUD.add_character_action_timeline(char_1)
	$GameBoard.add_child(char_1)
	
	var char_2 = blue_char_scene.instantiate()
	char_1.cell = Vector2(0, 0)
	$HUD.add_character_action_timeline(char_2)
	$GameBoard.add_child(char_2)
	
	for character in get_tree().get_nodes_in_group("characters"):
		print(character.name)
	perform_actions()
	
	
func perform_actions() -> void:
	for character in get_tree().get_nodes_in_group("characters"):
		if current_time == character.next_turn:
			current_character = character
			current_character.execute_move()
			print(character.character_name + "'s turn")
			current_character.is_selected = true
			$HUD/BottomPanel/Action_1.text = character.moves[0].move_name + " (" + str(character.moves[0].move_time) + "s)"
			$HUD/BottomPanel/Action_1.show()
			$HUD/BottomPanel/Action_2.text = character.moves[1].move_name + " (" + str(character.moves[1].move_time) + "s)"
			$HUD/BottomPanel/Action_2.show()
			$HUD/BottomPanel/Action_3.text = character.moves[2].move_name + " (" + str(character.moves[2].move_time) + "s)"
			$HUD/BottomPanel/Action_3.show()
			$HUD/BottomPanel/Character_name.text = character.character_name
			$HUD/BottomPanel/Character_name.show()
			$HUD/ActionTimelineVbox.get_node(current_character.character_name).make_active()
			return
	advance_time()
	await get_tree().create_timer(0.3).timeout
	perform_actions()
	
func advance_time():
	current_time += 1
	emit_signal("time_passed")
	for at in get_tree().get_nodes_in_group("action_timeline"):
		at.advance_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hud_action(ac_nr) -> void:
	await current_character.queue_move(ac_nr)
	await get_tree().create_timer(0.3).timeout
	current_character.is_selected = false
	perform_actions()
