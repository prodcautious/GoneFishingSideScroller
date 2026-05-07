extends Control

@onready var resolution_option_button: CustomOptionButton = %ResolutionOptionButton
@onready var window_mode_option_button: CustomOptionButton = %WindowModeOptionButton
@onready var v_sync_check_box: CustomCheckBox = %VSyncCheckBox

@onready var master_h_slider: HSlider = %MasterHSlider
@onready var music_h_slider: HSlider = %MusicHSlider
@onready var sfx_h_slider: HSlider = %SfxHSlider
@onready var master_percentage_label: Label = %MasterPercentageLabel
@onready var music_percentage_label: Label = %MusicPercentageLabel
@onready var sfx_percentage_label: Label = %SfxPercentageLabel

var is_setting_up : bool = false

#region Built-In
func _ready() -> void:
	_connect_signals()
	_register_menu()
	_set_up_default_settings()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and visible:
		get_viewport().set_input_as_handled()
		OptionsManager.save_options()
		MenuManager.close_current_menu()

func _on_visibility_changed() -> void:
	if visible:
		OptionsManager.load_options()
		_set_up_default_settings()
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

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.OPTIONS, self)

func _set_up_default_settings() -> void:
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

func _center_window() -> void:
	var window = get_window()
	var screen = window.current_screen
	
	var screen_pos = DisplayServer.screen_get_position(screen)
	var screen_size = DisplayServer.screen_get_size(screen)
	
	var window_size = window.get_size_with_decorations()
	
	window.set_position(screen_pos + (screen_size - window_size) / 2)
#endregion

#region Signals
func _on_resolution_selected(index: int) -> void:
	if is_setting_up:
		return
	var resolution = OptionsManager.RESOLUTIONS[index]
	get_window().size = resolution
	_center_window()
	resolution_option_button.select(index)
	OptionsManager.resolution_index = index

func _on_window_mode_selected(index: int) -> void:
	if is_setting_up:
		return
	match index:
		0:
			print("Options: Setting Window Mode to Fullscreen")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			OptionsManager.window_mode = 0
			window_mode_option_button.select(0)
		1:
			print("Options: Setting Window Mode to Windowed")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			OptionsManager.window_mode = 1
			window_mode_option_button.select(1)
		2:
			print("Options: Setting Window Mode to Borderless Windowed")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			OptionsManager.window_mode = 2
			window_mode_option_button.select(2)

func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if is_setting_up:
		return
	OptionsManager.v_sync = toggled_on
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_master_volume_changed(value: float) -> void:
	if is_setting_up:
		return
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db)

	master_percentage_label.text = str(int(value * 100)) + "%"
	OptionsManager.master_volume = value

func _on_music_volume_changed(value: float) -> void:
	if is_setting_up:
		return
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(1, db)

	music_percentage_label.text = str(int(value * 100)) + "%"
	OptionsManager.music_volume = value
	
func _on_sfx_volume_changed(value: float) -> void:
	if is_setting_up:
		return
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(2, db)

	sfx_percentage_label.text = str(int(value * 100)) + "%"
	OptionsManager.sfx_volume = value
#endregion
