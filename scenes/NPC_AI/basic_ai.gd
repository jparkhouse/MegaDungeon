extends Node
class_name BasicAi

var factions_relations:FactionRelations = preload("res://resources/factions_relations.tres")

func decide_move(character, board):
	var attack_action_index: int
	var has_attack: bool = false
	var move_action_index: int
	var has_move: bool = false
	var move_attack_action_index: int
	var has_move_attack: bool = false
	var parameters = {}
	
	for index in range(character.actions.size()):
		var action = character.actions[index]
		if action is AttackClass:
			attack_action_index = index
			has_attack = true
		elif action is MoveClass:
			move_action_index = index
			has_move = true
		elif action is MoveAttackClass:
			move_attack_action_index = index
			has_move_attack = true
	
	var enemy_distances = []
	var enemies_exist := false
	for child in board.get_children():
		if child.is_in_group("character"):
			if factions_relations.factions_relations[character.faction].single_faction_relations[child.faction] < 0:
				enemies_exist = true
				enemy_distances.append({
					"character":child,
					"distance":character.grid.calculate_distance(character.cell, child.cell)
				})
	if enemies_exist:
		enemy_distances.sort_custom(sort_by_distance)
		var closest_enemy = enemy_distances[0]

		if closest_enemy["distance"] <= character.actions[attack_action_index].range:
			parameters["target"] = closest_enemy["character"]
			print(character.name + " queues attack against " + closest_enemy["character"].name)
			return({"action_index":attack_action_index, "parameters":parameters})
		elif closest_enemy["distance"] <= character.actions[move_attack_action_index].total_range:
			parameters["target"] = closest_enemy["character"]
			print(character.name + " queues move-attack against " + closest_enemy["character"].name)
			return({"action_index":move_attack_action_index, "parameters":parameters})
		else:
			var line_to_enemy = character.grid.calculate_line(character.cell, closest_enemy["character"].cell)
			parameters["cell"] = line_to_enemy[character.actions[move_action_index].move_range]
			print(character.name + " queues move")
			return({"action_index":move_action_index, "parameters":parameters})
	else:
		parameters["cell"] = character.cell
		print(character.name + " waits")
		return({"action_index":move_action_index, "parameters":parameters})
	
	
func sort_by_distance(a, b):
	if a["distance"] < b["distance"]:
		return true
	return false
