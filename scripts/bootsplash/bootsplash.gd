extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skip_tooltip_h_box_container: HBoxContainer = %SkipTooltipHBoxContainer

var has_skipped: bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_bootsplash_finished)
	animation_player.play("bootsplash")
	await get_tree().create_timer(4.0, true).timeout
	if !has_skipped:
		AudioManager.play_song("start_menu_theme")
		MenuManager.show_menu(MenuManager.MenuState.START)

func _input(_event):
	if Input.is_action_just_pressed("skip_animation"):
		if has_skipped:
			return
		if animation_player.is_playing():
			if animation_player.current_animation_position >= 3.5:
				print("Cancelled too late, ignoring.")
			animation_player.seek(4.0, true)
			has_skipped = true
			AudioManager.play_song("start_menu_theme")
			MenuManager.show_menu(MenuManager.MenuState.START)

func _on_bootsplash_finished(_anim_name: String) -> void:
	get_parent().queue_free()
