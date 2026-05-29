extends Control

@onready var menu_margin_container: MarginContainer = %MenuMarginContainer
@onready var start_button: CustomButton = %StartButton
@onready var options_button: CustomButton = %OptionsButton
@onready var quit_button: CustomButton = %QuitButton
@onready var youtube_texture_button: CustomTextureButton = %YoutubeTextureButton
@onready var itch_texture_button: CustomTextureButton = %ItchTextureButton
@onready var version_label: Label = %VersionLabel

@export var main_scene: String = ""

var tween: Tween
var start_button_pressed: bool = false

func _ready() -> void:
	MenuManager.register_menu(MenuManager.MenuState.START, self)
	MenuManager.show_menu(MenuManager.MenuState.START)
	
	connect_signals()
	version_label.text = "v " + str(GameManager.current_version)

	pivot_offset = size / 2
	scale = Vector2.ZERO
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func connect_signals() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func _on_start_button_pressed() -> void:
	if main_scene && !start_button_pressed:
		SceneTransition.transition_scene(main_scene)
		GameManager.game_start.emit()
		start_button_pressed = true

func _on_options_button_pressed() -> void:
	OptionsManager.load_options()
	MenuManager.push_menu(MenuManager.MenuState.OPTIONS)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
