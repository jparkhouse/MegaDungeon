extends Node
@export var char_scene: PackedScene
var current_time: int
var current_character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_time = 0
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 6)
	
	var char_1 = char_scene.instantiate()
	char_1.move_times = [rng.randi_range(1, 6),rng.randi_range(1, 6),rng.randi_range(1, 6)]
	char_1.character_name = "Character A"
	$HUD.add_character_action_timeline(char_1)
	add_child(char_1)
	var char_2 = char_scene.instantiate()
	char_2.move_times = [rng.randi_range(1, 6),rng.randi_range(1, 6),rng.randi_range(1, 6)]
	char_2.character_name = "Character B"
	$HUD.add_character_action_timeline(char_2)
	add_child(char_2)
	var char_3 = char_scene.instantiate()
	char_3.move_times = [rng.randi_range(1, 6),rng.randi_range(1, 6),rng.randi_range(1, 6)]
	char_3.character_name = "Character C"
	$HUD.add_character_action_timeline(char_3)
	add_child(char_3)
	
	for character in get_tree().get_nodes_in_group("characters"):
		print(character.name)
	perform_actions()
	
	
func perform_actions() -> void:
	for character in get_tree().get_nodes_in_group("characters"):
		print(character.next_turn)
		if current_time == character.next_turn:
			current_character = character
			$HUD/BottomPanel/Action_1.text = "Action 1 (" + str(character.move_times[0]) + "s)"
			$HUD/BottomPanel/Action_1.show()
			$HUD/BottomPanel/Action_2.text = "Action 2 (" + str(character.move_times[1]) + "s)"
			$HUD/BottomPanel/Action_2.show()
			$HUD/BottomPanel/Action_3.text = "Action 3 (" + str(character.move_times[2]) + "s)"
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
	for at in get_tree().get_nodes_in_group("action_timeline"):
		at.advance_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hud_action(ac_nr) -> void:
	current_character.execute_move(ac_nr)
	await get_tree().create_timer(0.3).timeout
	perform_actions()
