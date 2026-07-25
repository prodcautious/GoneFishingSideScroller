extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skip_tooltip_h_box_container: HBoxContainer = %SkipTooltipHBoxContainer

var finished: bool = false

func _ready() -> void:
	_set_up_menu()
	_connect_signals()
	
	animation_player.play("bootsplash")
	await get_tree().create_timer(4.0, true).timeout
	
	_finish_bootsplash()

func _set_up_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.BOOTSPLASH, self)
	MenuManager.show_menu(MenuManager.MenuState.BOOTSPLASH, false)

func _connect_signals() -> void:
	animation_player.animation_finished.connect(_on_bootsplash_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_animation"):
		get_viewport().set_input_as_handled()
		
		if finished:
			return

		if animation_player.is_playing():
			if animation_player.current_animation_position >= 3.5:
				return

			animation_player.seek(animation_player.current_animation_length, true)
			animation_player.stop()

		_finish_bootsplash()

func _on_bootsplash_finished(_anim_name: String) -> void:
	_finish_bootsplash()

func _finish_bootsplash() -> void:
	if finished:
		return

	finished = true
	
	MenuManager.close_current_menu()
	MenuManager.show_menu(MenuManager.MenuState.START, false)
	AudioManager.play_song("start_menu_theme")
	print("Playing start theme")
	await get_tree().process_frame
	queue_free()
