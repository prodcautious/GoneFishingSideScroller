extends Node

var resolution_index: int = 2 #0 = 1920x1080 #1 = 960x540 #2 = 640 x 360 (Native) #3 = 480 x 270 
const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(960, 540),
	Vector2i(640,360),
	Vector2i(480, 270)
]

var window_mode: int = 1 #0 = Fullscreen #1 = Windowed #2 (Native) = Borderless Windowed
var v_sync: bool = true # VSync enabled (Native)

var master_volume: float = 1.0 # Default 1
var music_volume: float = 0.5 # Default 0.5
var sfx_volume: float = 0.5 # Default 0.5
var voice_volume: float = 0.5 # Default 0.5

func _ready() -> void:
	load_options()
	apply_video_settings()
	apply_audio_settings()
	get_tree().auto_accept_quit = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_options()
		get_tree().quit()

func save_options() -> void:
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(resolution_index)
	file.store_var(window_mode)
	file.store_var(v_sync)
	
	file.store_var(master_volume)
	file.store_var(music_volume)
	file.store_var(sfx_volume)
	file.store_var(voice_volume)

func load_options() -> void:
	if FileAccess.file_exists("user://save_game.dat"):
		var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
		if file:
			resolution_index = file.get_var()
			window_mode = file.get_var()
			v_sync = file.get_var()
			
			master_volume = file.get_var()
			music_volume = file.get_var()
			sfx_volume = file.get_var()
			voice_volume = file.get_var()
			
			file.close()
			print("Options loaded successfully")
		else:
			print("Failed to open save file")
	else:
		print("No save file found, using defaults")

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))
	AudioServer.set_bus_volume_db(3, linear_to_db(voice_volume))

func apply_video_settings() -> void:
	resolution_index = clampi(resolution_index, 0, RESOLUTIONS.size() - 1)
	window_mode = clampi(window_mode, 0, 2)

	var resolution: Vector2i = RESOLUTIONS[resolution_index]

	match window_mode:
		0:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		1:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(resolution)
			await get_tree().process_frame
			center_window()

		2:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(resolution)
			await get_tree().process_frame
			center_window()

	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if v_sync else DisplayServer.VSYNC_DISABLED
	)

func center_window() -> void:
	var screen := DisplayServer.window_get_current_screen()
	var screen_rect := DisplayServer.screen_get_usable_rect(screen)
	var window_size := DisplayServer.window_get_size_with_decorations()

	var centered_position := screen_rect.position + ((screen_rect.size - window_size) / 2)

	DisplayServer.window_set_position(centered_position)
