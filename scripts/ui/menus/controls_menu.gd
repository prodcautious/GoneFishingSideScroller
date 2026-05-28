extends Control

#region Built-In
func _ready() -> void:
	MenuManager.register_menu(MenuManager.MenuState.CONTROLS, self)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") && visible:
		get_viewport().set_input_as_handled()
		MenuManager.pop_menu()
#endregion
