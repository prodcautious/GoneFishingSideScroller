extends Control

##Direct path to start menu scene
@export var start_menu_scene: String = ""

@onready var resume_button: CustomButton = %ResumeButton
@onready var options_button: CustomButton = %OptionsButton
@onready var controls_button: CustomButton = %ControlsButton
@onready var main_menu_button: CustomButton = %MainMenuButton
@onready var quit_button: CustomButton = %QuitButton

@onready var panel_container: PanelContainer = %PanelContainer

#region Built-In
func _ready() -> void:
	hide()
	_register_menu()
	_connect_signals()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		_toggle_visibility()
#endregion

#region Helpers
func _connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	SignalManager.game_start.connect(_on_game_start)

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.PAUSE, self)

func _toggle_visibility() -> void:
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
#endregion

#region Signals
func _on_game_start() -> void:
	# re-register menu when player goes back to start menu
	_register_menu()

func _on_resume_button_pressed() -> void:
	_toggle_visibility()

func _on_options_button_pressed() -> void:
	print("opening optinons menu")
	MenuManager.show_menu(MenuManager.MenuState.OPTIONS, true)
	OptionsManager.load_options()

func _on_controls_button_pressed() -> void:
	MenuManager.show_menu(MenuManager.MenuState.CONTROLS, true)

func _on_main_menu_button_pressed() -> void:
	if start_menu_scene:
		SceneTransition.transition_scene(start_menu_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
#endregion
