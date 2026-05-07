extends Node

enum MenuState {
	NONE,
	START,
	PAUSE,
	OPTIONS,
	CONTROLS,
	INVENTORY,
	TELEPORT,
	SHOP
}

var current_menu: MenuState = MenuState.NONE
var menus: Dictionary = {}

func register_menu(menu_state: MenuState, menu_node: Control) -> void:
	print("Menu Manager: Registered " + str(menu_state) + " | " + str(menu_node))
	menus[menu_state] = menu_node
	menu_node.hide()

func show_menu(menu_state: MenuState, pause_game: bool = false) -> void:
	print("Menu Manager: Showing " + str(menu_state))
	hide_all_menus()

	current_menu = menu_state

	if menus.has(menu_state):
		menus[menu_state].show()
	get_tree().paused = pause_game

func hide_all_menus() -> void:
	print("Menu Manager: Hiding all menus")
	for menu in menus.values():
		if is_instance_valid(menu):
			menu.hide()

func is_menu_open() -> bool:
	return current_menu != MenuState.NONE

func is_open(menu_state: MenuState) -> bool:
	return current_menu == menu_state

func close_current_menu() -> void:
	print("Menu Manager: Closing all menus")
	hide_all_menus()
	current_menu = MenuState.NONE
	get_tree().paused = false
