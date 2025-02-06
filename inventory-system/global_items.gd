extends Node

var items: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = read_from_JSON("res://inventory-system/assets/json/items.json")
	for key in items.keys():
		# gives each item a unique identifier for dedupe
		items[key]["key"] = key
	print(get_item_by_key("sword"))

func read_from_JSON(path: String) -> Dictionary:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			printerr("Error parsing JSON from file: ", path)
			return {}
	else:
		printerr("Invalid path to file given")
		return {}

func get_item_by_key(key: String) -> Dictionary:
	if items and items.has(key):
		return items[key].duplicate(true)
	elif items:
		printerr("Item ", key, " not found")
		return {}
	else:
		printerr("items is empty")
		return {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
