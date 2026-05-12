extends Node

var resolution_index: int = 2 #0 = 1920x1080 #1 = 960x540 #2 = 640 x 360 (Native) #3 = 480 x 270 
const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(960, 540),
	Vector2i(640,360),
	Vector2i(480, 270)
]

var window_mode: int = 1 #0 = Fullscreen #1 = Windowed #2 (Native) = Borderless Windowed #3 = Borderless Fullscreen
var v_sync: bool = true # VSync enabled (Native)

var master_volume: float = 1.0 # Default 1
var music_volume: float = 0.5 # Default 0.5
var sfx_volume: float = 0.5 # Default 0.5

func _ready() -> void:
	load_options()
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

func load_options():
	if FileAccess.file_exists("user://save_game.dat"):
		var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
		if file:
			resolution_index = file.get_var()
			window_mode = file.get_var()
			v_sync = file.get_var()
			
			master_volume = file.get_var()
			music_volume = file.get_var()
			sfx_volume = file.get_var()
			
			file.close()
			apply_audio_settings()
			print("Options loaded successfully")
		else:
			print("Failed to open save file")
	else:
		print("No save file found, using defaults")
		apply_audio_settings()

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))
