extends Node

var faction_relations:FactionRelations = preload("res://resources/factions_relations.tres")

func decide_move(character, board):
	var attack_action_nr: int
	var has_attack: bool = false
	var move_action_nr: int
	var has_move: bool = false
	var move_attack_action_nr: int
	var has_move_attack: bool = false
	var parameters = {}
	
	for index in range(character.actions.size()):
		var action = character.actions[index]
		if action is AttackClass:
			attack_action_nr = index
			has_attack = true
		elif action is MoveClass:
			move_action_nr = index
			has_move = true
		elif action is MoveAttackClass:
			move_attack_action_nr = index
			has_move_attack = true
	
	var enemy_distances = []
	var enemies_exist := false
	for child in board.get_children():
		if child.is_in_group("character"):
			if faction_relations[character.faction][child.faction] < 0:
				enemies_exist = true
				enemy_distances.append({
					"character":child,
					"distance":character.grid.calculate_distance(character.cell, child.cell)
				})
	if enemies_exist:
		enemy_distances.sort_custom(sort_by_distance)
		var closest_enemy = enemy_distances[0]

		if closest_enemy["distance"] <= character.actions[attack_action_nr].range:
			pass # attack that enemy
		elif closest_enemy["distance"] <= character.actions[move_attack_action_nr].total_range:
			pass # move attack that enemy
		else:
			pass # move towards that enemy
	else:
		pass # move to random adjacent tile
	
	
func sort_by_distance(a, b):
	if a["distance"] < b["distance"]:
		return true
	return false
