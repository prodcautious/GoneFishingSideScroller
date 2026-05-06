extends Node2D

@export var catch_modifier: String = "Campfire"

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var point_light_2d: PointLight2D = %PointLight2D
@onready var flicker_timer: Timer = %FlickerTimer
@onready var area_2d: Area2D = %Area2D

func _ready() -> void:
	flicker_timer.wait_time = randf_range(1,3)
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	flicker_timer.start()
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)
	animated_sprite_2d.play("default")

func _on_flicker_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(point_light_2d, "scale", Vector2(0.85,0.85), 0.1)
	tween.tween_property(point_light_2d, "scale", Vector2(0.9,0.9), 0.1)
	flicker_timer.wait_time = randf_range(1,3)
	flicker_timer.start()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		var fishing_rod = area.get_parent().fishing_rod
		fishing_rod.current_catch_modifier = catch_modifier
		print("Current catch modifier: " + fishing_rod.current_catch_modifier)

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		var fishing_rod = area.get_parent().fishing_rod
		fishing_rod.current_catch_modifier = ""
		print("Current catch modifier: " + fishing_rod.current_catch_modifier)
