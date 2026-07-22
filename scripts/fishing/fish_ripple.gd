extends Node2D
class_name FishRipple

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("ripples")
