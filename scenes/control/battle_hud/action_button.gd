extends Button

var action_key
signal action_button_pressed

func _on_pressed() -> void:
	action_button_pressed.emit(action_key)
