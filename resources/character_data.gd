class_name CharacterData
extends Entity

@export var skin: Texture
@export var actions: Array[ActionClass]
@export var character_name: String
@export var max_health: int
@export var health: int = max_health
@export var faction: Enums.factions
@export var ai: PackedScene = preload("res://scenes/NPC_AI/basic_ai.tscn")
@export var is_in_party : bool = false

var scene := preload("res://scenes/entities/character.tscn")
