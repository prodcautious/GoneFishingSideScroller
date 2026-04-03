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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	connect_signals()

func connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if GameManager.inventory_open || GameManager.in_shop_ui:
			return
		else:
			get_viewport().set_input_as_handled()
			toggle_visibility()

func toggle_visibility() -> void:
	if options_menu_opened:
		options_menu_opened = false
		panel_container.show()
		return
	
	if controls_menu_opened:
		controls_menu_opened = false
		panel_container.show()
		return

	if visible:
		hide()
		get_tree().paused = false
		GameManager.paused = false
		AudioManager.muffle_music(false)
	else:
		show()
		get_tree().paused = true
		GameManager.paused = true
		AudioManager.muffle_music(true)

func _on_resume_button_pressed() -> void:
	toggle_visibility()

func _on_options_button_pressed() -> void:
	OptionsManager.load_options()
	options_menu_opened = true
	options_menu.show()
	panel_container.hide()
	options_menu.set_up_default_settings()

func _on_controls_button_pressed() -> void:
	controls_menu_opened = true
	controls_menu.show()
	panel_container.hide()

func _on_main_menu_button_pressed() -> void:
	AudioManager.muffle_music(false)
	if start_menu_scene:
		SceneTransition.transition_scene(start_menu_scene)
func _on_quit_button_pressed() -> void:
	get_tree().quit()
