extends Button

var action_key : int
signal action_button_pressed

func _on_pressed() -> void:
	action_button_pressed.emit(action_key)
