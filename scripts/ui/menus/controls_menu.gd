extends Control

#region Built-In
func _ready() -> void:
	_register_menu()
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") && visible:
		_close_controls()
#endregion

#region Helpers
func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.CONTROLS, self)

func _close_controls() -> void:
	hide()
	get_tree().paused = false
#endregion
