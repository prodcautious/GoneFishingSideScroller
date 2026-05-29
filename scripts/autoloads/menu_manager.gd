extends Node

enum MenuState {
	NONE,
	START,
	PAUSE,
	OPTIONS,
	NAMEINPUT,
	ACCESSORIES,
	INVENTORY,
	TELEPORT,
	SHOP
}

var current_menu: MenuState = MenuState.NONE
var menus: Dictionary = {}

func register_menu(menu_state: MenuState, menu_node: Control) -> void:
	menus[menu_state] = menu_node
	menu_node.hide()

func show_menu(menu_state: MenuState, pause_game: bool = false) -> void:
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

func close_current_menu() -> void:
	hide_all_menus()
	current_menu = MenuState.NONE
	get_tree().paused = false

var menu_stack: Array[MenuState] = []

func push_menu(menu_state: MenuState, pause_game: bool = false) -> void:
	# Hides current menu but remembers its state
	if current_menu != MenuState.NONE:
		menu_stack.push_back(current_menu)
		if menus.has(current_menu):
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
	else:
		current_menu = menu_stack.pop_back()
		if menus.has(current_menu):
			menus[current_menu].show()
