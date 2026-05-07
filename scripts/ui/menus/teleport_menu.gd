extends Control

@onready var greava_main_button: CustomButton = %GreavaMainButton
@onready var shop_button: CustomButton = %ShopButton

#region Built-In
func _ready() -> void:
	_connect_signals()
	_register_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("teleport_menu"):
		get_viewport().set_input_as_handled()

		if MenuManager.is_menu_open() and not MenuManager.is_open(MenuManager.MenuState.TELEPORT):
			return

		_toggle_teleport_menu()

	elif event.is_action_pressed("esc") and MenuManager.is_open(MenuManager.MenuState.TELEPORT):
		get_viewport().set_input_as_handled()
		MenuManager.close_current_menu()
#endregion

#region Helpers
func _connect_signals() -> void:
	greava_main_button.pressed.connect(_on_greava_main_pressed)
	shop_button.pressed.connect(_on_shop_pressed)

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.TELEPORT, self)

func _toggle_teleport_menu() -> void:
	if MenuManager.is_open(MenuManager.MenuState.TELEPORT):
		MenuManager.close_current_menu()
	else:
		MenuManager.show_menu(MenuManager.MenuState.TELEPORT)
#endregion

#region Signals
func _on_greava_main_pressed() -> void:
	MenuManager.close_current_menu()
	SceneTransition.transition_scene("res://scenes/areas/main.tscn", Vector2(-19, -1), 1)

func _on_shop_pressed() -> void:
	MenuManager.close_current_menu()
	SceneTransition.transition_scene("res://scenes/areas/tackle_shop.tscn", Vector2(10, 7), -1)
#endregion
