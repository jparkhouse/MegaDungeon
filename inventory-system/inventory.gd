extends Node

signal items_changed(indexes: Array[int])

var cols: int = 9
var rows: int = 3
var slots: int = cols * rows
var items: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(slots):
		items.append({})
		
func set_item(index: int, item: Dictionary) -> Dictionary:
	var previous_item = items[index]
	items[index] = item
	emit_signal("items_changed", [index])
	return previous_item
	
func remove_item(index: int) -> Dictionary:
	var previous_item = items[index]
	items[index] = {}
	emit_signal("items_changed", [index])
	return previous_item

func set_item_quantity(index: int, amount: int):
	if !items[index]:
		printerr("nothing in slot ", index)
		return
	if !items[index]["stackable"]:
		printerr("Item at index ", index, " cannot be stacked")
		return
	items[index]["quantity"] += amount
	if items[index]["quantity"] <= 0:
		remove_item(index)
	else:
		emit_signal("item_changed", [index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
