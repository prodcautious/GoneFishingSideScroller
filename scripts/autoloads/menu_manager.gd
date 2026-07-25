extends Node

enum MenuState {
	NONE,
	BOOTSPLASH,
	START,
	PAUSE,
	OPTIONS,
	NAMEINPUT,
	ACCESSORIES,
	INVENTORY,
	DEBUG,
	CONSOLE,
	SHOP
}

var current_menu: MenuState = MenuState.NONE
var menus: Dictionary = {}

func register_menu(menu_state: MenuState, menu_node: Control) -> void:
	menus[menu_state] = menu_node
	menu_node.hide()

func show_menu(menu_state: MenuState, pause_game: bool = false) -> void:
	menu_stack.clear()
	hide_all_menus()

	current_menu = menu_state

	if menus.has(menu_state):
		menus[menu_state].show()

	get_tree().paused = pause_game

func hide_all_menus() -> void:
	for menu in menus.values():
		if is_instance_valid(menu):
			menu.hide()

func is_menu_open() -> bool:
	return current_menu != MenuState.NONE

func is_open(menu_state: MenuState) -> bool:
	return current_menu == menu_state

func close_current_menu(unpause_game: bool = false) -> void:
	hide_all_menus()
	current_menu = MenuState.NONE
	if unpause_game:
		get_tree().paused = false

var menu_stack: Array[MenuState] = []

func push_menu(menu_state: MenuState, pause_game: bool = false, hide_menu: bool = false) -> void:
	if current_menu != MenuState.NONE:
		menu_stack.push_back(current_menu)
		if hide_menu and menus.has(current_menu):
			menus[current_menu].hide()
	current_menu = menu_state
	if menus.has(menu_state):
		menus[menu_state].show()
	get_tree().paused = pause_game

func pop_menu() -> void:
	if menus.has(current_menu):
		menus[current_menu].hide()

	if menu_stack.is_empty():
		current_menu = MenuState.NONE
		get_tree().paused = false
		return

	current_menu = menu_stack.pop_back()

	if menus.has(current_menu):
		menus[current_menu].show()

	get_tree().paused = menu_pauses_game(current_menu)

func menu_pauses_game(menu_state: MenuState) -> bool:
	return menu_state in [
		MenuState.PAUSE,
		MenuState.OPTIONS,
		MenuState.NAMEINPUT,
		MenuState.SHOP
	]
