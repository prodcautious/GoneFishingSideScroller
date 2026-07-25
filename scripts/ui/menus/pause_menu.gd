extends Control

##Direct path to start menu scene
@export var start_menu_scene: String = ""

@onready var resume_button: CustomButton = %ResumeButton
@onready var options_button: CustomButton = %OptionsButton
@onready var main_menu_button: CustomButton = %MainMenuButton
@onready var quit_button: CustomButton = %QuitButton
@onready var v_box_container: VBoxContainer = %VBoxContainer

var player
var tween: Tween

#region Built-In
func _ready() -> void:
	hide()
	_register_menu()
	_connect_signals()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		_toggle_visibility()
	elif event.is_action_pressed("close_menu") && visible:
		get_viewport().set_input_as_handled()
		_toggle_visibility()
#endregion

#region Helpers
func _connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	GameManager.game_start.connect(_on_game_start)

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.PAUSE, self)

func _toggle_visibility() -> void:
	if SceneTransition.is_transitioning:
		return

	if MenuManager.current_menu in [
		MenuManager.MenuState.BOOTSPLASH,
		MenuManager.MenuState.START,
		MenuManager.MenuState.CONSOLE
	]:
		return

	if visible and MenuManager.current_menu != MenuManager.MenuState.PAUSE :
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.lock()
		MenuManager.show_menu(MenuManager.MenuState.PAUSE, true)
		_tween_in()
		return

	if visible:
		_tween_out()
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.unlock()
		MenuManager.close_current_menu(true)
	else:
		_tween_in()
		MenuManager.show_menu(MenuManager.MenuState.PAUSE, true)

func _tween_in() -> void:
	if tween:
		tween.kill()

	v_box_container.pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(v_box_container, "scale", Vector2(1.1,1.1), 0.1)
	tween.tween_property(v_box_container, "scale", Vector2(1.0,1.0), 0.1)

func _tween_out() -> void:
	if tween:
		tween.kill()

	v_box_container.pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(v_box_container, "scale", Vector2(1.1,1.1), 0.1)
	tween.tween_property(v_box_container, "scale", Vector2(0.0,0.0), 0.1)
#endregion

#region Signals
func _on_game_start() -> void:
	# re-register menu when player goes back to start menu
	_register_menu()

func _on_resume_button_pressed() -> void:
	_toggle_visibility()

func _on_options_button_pressed() -> void:
	MenuManager.push_menu(MenuManager.MenuState.OPTIONS, true)
	OptionsManager.load_options()

func _on_main_menu_button_pressed() -> void:
	if start_menu_scene:
		MenuManager.close_current_menu()
		await SceneTransition.transition_scene(start_menu_scene, Vector2.ZERO, 1.0, false)
		AudioManager.play_song("start_menu_theme")
		MenuManager.show_menu(MenuManager.MenuState.START)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
#endregion
