extends Control

@export var next_scene: String = ""

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skip_tooltip_h_box_container: HBoxContainer = %SkipTooltipHBoxContainer

var has_skipped: bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_bootsplash_finished)
	animation_player.play("bootsplash")

func _input(event):
	if Input.is_action_just_pressed("skip_animation"):
		if has_skipped:
			return
		if animation_player.is_playing():
			animation_player.seek(4.0, true)
			has_skipped = true

func _on_bootsplash_finished(_anim_name: String) -> void:
	if !next_scene:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		get_tree().change_scene_to_file(next_scene)
