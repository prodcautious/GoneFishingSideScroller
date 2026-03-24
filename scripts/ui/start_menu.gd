extends Control

@onready var menu_margin_container: MarginContainer = %MenuMarginContainer
@onready var start_button: CustomButton = %StartButton
@onready var options_button: CustomButton = %OptionsButton
@onready var quit_button: CustomButton = %QuitButton
@onready var options_menu: Control = %OptionsMenu
@onready var youtube_label: Label = %YoutubeLabel
@onready var youtube_texture_button: CustomTextureButton = %YoutubeTextureButton
@onready var itch_label: Label = %ItchLabel
@onready var itch_texture_button: CustomTextureButton = %ItchTextureButton

@export var main_scene: String = ""

var tween: Tween

func _ready() -> void:
	if !AudioManager.music_player:
		AudioManager.play_music("default")
	connect_signals()
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
	youtube_texture_button.mouse_entered.connect(_on_youtube_button_mouse_entered)
	youtube_texture_button.mouse_exited.connect(_on_youtube_button_mouse_exited)
	itch_texture_button.mouse_entered.connect(_on_itch_button_mouse_entered)
	itch_texture_button.mouse_exited.connect(_on_itch_button_mouse_exited)

func _on_start_button_pressed() -> void:
	if main_scene:
		SceneTransition.transition_scene(main_scene)

func _on_options_button_pressed() -> void:
	OptionsManager.load_options()
	options_menu.show()
	options_menu.set_up_default_settings()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_youtube_button_mouse_entered() -> void:
	youtube_label.show()

func _on_youtube_button_mouse_exited() -> void:
	youtube_label.hide()

func _on_itch_button_mouse_entered() -> void:
	itch_label.show()

func _on_itch_button_mouse_exited() -> void:
	itch_label.hide()
