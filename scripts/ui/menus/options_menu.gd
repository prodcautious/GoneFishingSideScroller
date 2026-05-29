extends Control

@onready var resolution_option_button: CustomOptionButton = %ResolutionOptionButton
@onready var window_mode_option_button: CustomOptionButton = %WindowModeOptionButton
@onready var v_sync_check_box: CustomCheckBox = %VSyncCheckBox

@onready var master_h_slider: HSlider = %MasterHSlider
@onready var music_h_slider: HSlider = %MusicHSlider
@onready var sfx_h_slider: HSlider = %SfxHSlider
@onready var voice_h_slider: HSlider = %VoiceHSlider

@onready var master_percentage_label: Label = %MasterPercentageLabel
@onready var music_percentage_label: Label = %MusicPercentageLabel
@onready var sfx_percentage_label: Label = %SfxPercentageLabel
@onready var voice_percentage_label: Label = %VoicePercentageLabel

var is_setting_up : bool = false

#region Built-In
func _ready() -> void:
	MenuManager.register_menu(MenuManager.MenuState.OPTIONS, self)
	_connect_signals()
	set_up_default_settings()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and visible:
		get_viewport().set_input_as_handled()
		OptionsManager.save_options()
		MenuManager.pop_menu()

func _on_visibility_changed() -> void:
	if visible:
		set_up_default_settings()
#endregion

#region Helpers
func _connect_signals() -> void:
	# Video
	resolution_option_button.item_selected.connect(_on_resolution_selected)
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)
	v_sync_check_box.toggled.connect(_on_v_sync_check_box_toggled)
	
	# Audio
	master_h_slider.value_changed.connect(_on_master_volume_changed)
	music_h_slider.value_changed.connect(_on_music_volume_changed)
	sfx_h_slider.value_changed.connect(_on_sfx_volume_changed)
	voice_h_slider.value_changed.connect(_on_voice_volume_changed)

func register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.OPTIONS, self)
	MenuManager.show_menu(MenuManager.MenuState.OPTIONS, true)

func set_up_default_settings() -> void:
	is_setting_up = true

	window_mode_option_button.select(OptionsManager.window_mode)
	resolution_option_button.select(OptionsManager.resolution_index)
	v_sync_check_box.button_pressed = OptionsManager.v_sync

	master_h_slider.value = OptionsManager.master_volume
	music_h_slider.value = OptionsManager.music_volume
	sfx_h_slider.value = OptionsManager.sfx_volume

	master_percentage_label.text = str(int(OptionsManager.master_volume * 100)) + "%"
	music_percentage_label.text = str(int(OptionsManager.music_volume * 100)) + "%"
	sfx_percentage_label.text = str(int(OptionsManager.sfx_volume * 100)) + "%"

	is_setting_up = false
#endregion

#region Signals
func _on_resolution_selected(index: int) -> void:
	if is_setting_up:
		return

	OptionsManager.resolution_index = index
	OptionsManager.apply_video_settings()
	OptionsManager.save_options()

func _on_window_mode_selected(index: int) -> void:
	if is_setting_up:
		return

	OptionsManager.window_mode = index
	OptionsManager.apply_video_settings()
	OptionsManager.save_options()

func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if is_setting_up:
		return

	OptionsManager.v_sync = toggled_on
	OptionsManager.apply_video_settings()
	OptionsManager.save_options()

func _on_master_volume_changed(value: float) -> void:
	if is_setting_up:
		return

	OptionsManager.master_volume = value
	OptionsManager.apply_audio_settings()
	OptionsManager.save_options()
	master_percentage_label.text = str(int(value * 100)) + "%"

func _on_music_volume_changed(value: float) -> void:
	if is_setting_up:
		return

	OptionsManager.music_volume = value
	OptionsManager.apply_audio_settings()
	OptionsManager.save_options()
	music_percentage_label.text = str(int(value * 100)) + "%"

	
func _on_sfx_volume_changed(value: float) -> void:
	if is_setting_up:
		return

	OptionsManager.sfx_volume = value
	OptionsManager.apply_audio_settings()
	OptionsManager.save_options()
	sfx_percentage_label.text = str(int(value * 100)) + "%"

func _on_voice_volume_changed(value: float) -> void:
	if is_setting_up:
		return

	OptionsManager.voice_volume = value
	OptionsManager.apply_audio_settings()
	OptionsManager.save_options()
	voice_percentage_label.text = str(int(value * 100)) + "%"
#endregion
