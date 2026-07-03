extends Node

var music = {
	"start_menu_theme": preload("res://assets/audio/music/start_menu_theme.ogg"),
	"greava_theme": preload("res://assets/audio/music/greava_theme.ogg"),
	"tackle_shop_theme": preload("res://assets/audio/music/tackle_shop_theme.ogg")
}

var sfx = {
	"ui_pressed": preload("res://assets/audio/sfx/ui_pressed.ogg"),
	"cast_progress": preload("res://assets/audio/sfx/cast_progress.ogg"),
	"perfect_cast": preload("res://assets/audio/sfx/perfect_cast.ogg"),
	"fish_caught": preload("res://assets/audio/sfx/fish_caught.ogg"),
	"fish_got_away": preload("res://assets/audio/sfx/fish_got_away.ogg"),
	"sell_item": preload("res://assets/audio/sfx/sell_item.ogg")
}

var voices = {
	"fisherman": preload("res://assets/audio/voices/fisherman.ogg"),
}

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var voice_player: AudioStreamPlayer

func play_song(song_name: String) -> void:
	if music_player:
		music_player.queue_free()
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	music_player.bus = "Music"
	
	var song = music[song_name]
	music_player.stream = song
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	music_player.play()
	print("Playing Song: " + song_name + " | " + str(song))

func play_sfx(sfx_name: String, pitch: float = 1.0) -> void:
	if sfx_player:
		sfx_player.queue_free()
	
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	
	sfx_player.bus = "SFX"
	
	var sound_effect = sfx[sfx_name]
	sfx_player.stream = sound_effect
	
	if pitch:
		sfx_player.pitch_scale = pitch

	sfx_player.play()
	print("Playing SFX: " + sfx_name + " | " + str(sound_effect))
	await sfx_player.finished
	sfx_player.queue_free()

func play_voice(voice_name: String, pitch: float = 1.0) -> void:
	if voice_player:
		voice_player.queue_free()
	
	voice_player = AudioStreamPlayer.new()
	add_child(voice_player)
	
	voice_player.bus = "Voice"
	
	var voice = voices[voice_name]
	voice_player.stream = voice
	
	if pitch:
		voice_player.pitch_scale = pitch
	
	voice_player.play()

func fade_in_audio(duration: float = 1.0) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	
	var target_db = linear_to_db(OptionsManager.music_volume)
	
	AudioServer.set_bus_volume_db(bus_index, -80.0)
	
	if music_player:
		music_player.stream_paused = false

	var tween = create_tween()
	tween.tween_method(
		func(volume_db):
			AudioServer.set_bus_volume_db(bus_index, volume_db),
		-80.0,
		target_db,
		duration
	)

func fade_out_audio(duration: float = 1.0) -> void:
	var bus_index = AudioServer.get_bus_index("Music")

	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.tween_method(
		func(volume_db):
			AudioServer.set_bus_volume_db(bus_index, volume_db),
		AudioServer.get_bus_volume_db(bus_index),
		-80.0,
		duration
	)

	await tween.finished

	if music_player:
		music_player.stream_paused = true

	if sfx_player:
		sfx_player.queue_free()

# Not really being utilized yet :P
func pick_background_music() -> void:
	if music_player:
		music_player.queue_free()
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	music_player.bus = "Music"
	
	var options = []
	
	for song in music:
		if song.contains("background"):
			options.append(music[song])
	
	if !options.is_empty():
		var song = options.pick_random()
		music_player.stream = song
		music_player.play()
		print("Playing Random Background Music: " + str(song))
