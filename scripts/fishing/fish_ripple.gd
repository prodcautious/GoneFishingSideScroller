extends Node2D
class_name FishRipple

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_timer: Timer = %DeathTimer

func _ready() -> void:
	animation_player.play("ripples")
	death_timer.wait_time = randf_range(25.0,45.0)
	death_timer.timeout.connect(_on_death_timer_timeout)

func _on_death_timer_timeout() -> void:
	queue_free()
