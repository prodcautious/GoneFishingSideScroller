extends Control

@export var start_menu_scene: String = ""

@onready var resume_button: CustomButton = %ResumeButton
@onready var options_button: CustomButton = %OptionsButton
@onready var controls_button: CustomButton = %ControlsButton
@onready var main_menu_button: CustomButton = %MainMenuButton
@onready var quit_button: CustomButton = %QuitButton

@onready var panel_container: PanelContainer = %PanelContainer

@onready var options_menu: Control = %OptionsMenu
@onready var controls_menu: Control = %ControlsMenu

var options_menu_opened: bool = false
var controls_menu_opened: bool = false

func _ready() -> void:
	hide()

	MenuManager.register_menu(MenuManager.MenuState.PAUSE, panel_container)
	MenuManager.register_menu(MenuManager.MenuState.OPTIONS, options_menu)
	MenuManager.register_menu(MenuManager.MenuState.CONTROLS, controls_menu)
	MenuManager.hide_all_menus()
	MenuManager.current_menu = MenuManager.MenuState.NONE
	
	connect_signals()

func connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		toggle_visibility()

func toggle_visibility() -> void:
	if MenuManager.current_menu == MenuManager.MenuState.START:
		return

	if visible and MenuManager.current_menu != MenuManager.MenuState.PAUSE :
		get_tree().paused = true
		MenuManager.show_menu(MenuManager.MenuState.PAUSE, true)
		return

	if visible:
		hide()
		get_tree().paused = false
		MenuManager.close_current_menu()
	else:
		show()
		MenuManager.show_menu(MenuManager.MenuState.PAUSE, true)

func _on_resume_button_pressed() -> void:
	toggle_visibility()

func _on_options_button_pressed() -> void:
	MenuManager.show_menu(MenuManager.MenuState.OPTIONS, true)
	OptionsManager.load_options()
	options_menu.set_up_default_settings()

func _on_controls_button_pressed() -> void:
	MenuManager.show_menu(MenuManager.MenuState.CONTROLS, true)

func _on_main_menu_button_pressed() -> void:
	if start_menu_scene:
		SceneTransition.transition_scene(start_menu_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
