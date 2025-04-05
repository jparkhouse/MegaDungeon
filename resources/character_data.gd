class_name CharacterData
extends Entity

@export var skin: Texture
@export var actions: Array[ActionClass]
@export var character_name: String
@export var max_health: int
@export var move_range: int = 2
@export var health: int = max_health

var scene := preload("res://scenes/entities/character.tscn")
