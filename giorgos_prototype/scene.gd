extends Node

@export var red_char_scene: PackedScene
@export var blue_char_scene: PackedScene
@export var yellow_char_scene: PackedScene
@export var green_char_scene: PackedScene

@export var obstacle_scene: PackedScene
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
	$GameBoard.add_child(char_1)
	
	var char_2 = blue_char_scene.instantiate()
	char_2.cell = Vector2(5, 4)
	$GameBoard.add_child(char_2)

	var char_3 = green_char_scene.instantiate()
	char_3.cell = Vector2(4, 5)
	$GameBoard.add_child(char_3)
	
	var char_4 = yellow_char_scene.instantiate()
	char_4.cell = Vector2(0, 0)
	$GameBoard.add_child(char_4)
	
	var obst = obstacle_scene.instantiate()
	obst.cell = Vector2(1,1)
	$GameBoard.add_child(obst)
	obst = obstacle_scene.instantiate()
	obst.cell = Vector2(3,2)
	$GameBoard.add_child(obst)
	obst = obstacle_scene.instantiate()
	obst.cell = Vector2(4,3)
	$GameBoard.add_child(obst)
	obst = obstacle_scene.instantiate()
	obst.cell = Vector2(1,4)
	$GameBoard.add_child(obst)
	
	$GameBoard.reinitialize()
	
	for character in get_tree().get_nodes_in_group("characters"):
		$HUD.add_character_action_timeline(character)
		print(character.name)
	perform_actions()
	
	
func perform_actions() -> void:
	$GameBoard.reinitialize()
	for character in get_tree().get_nodes_in_group("characters"):
		if current_time == character.next_turn:
			current_character = character
			current_character.execute_action()
			print(character.character_name + "'s turn")
			current_character.is_selected = true
			$HUD/BottomPanel/Action_1.text = character.actions[0].action_name + " (" + str(character.actions[0].action_time) + "s)"
			$HUD/BottomPanel/Action_1.show()
			$HUD/BottomPanel/Action_2.text = character.actions[1].action_name + " (" + str(character.actions[1].action_time) + "s)"
			$HUD/BottomPanel/Action_2.show()
			$HUD/BottomPanel/Action_3.text = character.actions[2].action_name + " (" + str(character.actions[2].action_time) + "s)"
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
	await current_character.cancel_action()
	await current_character.queue_action(ac_nr)
	await get_tree().create_timer(0.3).timeout
	current_character.is_selected = false
	perform_actions()
