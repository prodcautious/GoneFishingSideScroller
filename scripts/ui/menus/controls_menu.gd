extends Control

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") && visible:
		close_controls()

func close_controls() -> void:
	hide()
	get_tree().paused = false
