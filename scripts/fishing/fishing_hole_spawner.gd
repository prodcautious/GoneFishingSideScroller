extends Node2D

@export var fishing_ripple_scene: PackedScene
@onready var fishing_ripple_collision_shape_2d: CollisionShape2D = %FishingRippleCollisionShape2D
@onready var fish_ripple_timer: Timer = %FishRippleTimer

func _ready() -> void:
	fish_ripple_timer.wait_time = randf_range(5.0, 15.0)
	fish_ripple_timer.start()
	fish_ripple_timer.timeout.connect(_on_fish_ripple_timer_timeout)

func _on_fish_ripple_timer_timeout() -> void:
	_spawn_fish_ripple()
	fish_ripple_timer.wait_time = randf_range(5.0, 15.0)
	fish_ripple_timer.start()

func _spawn_fish_ripple() -> void:
	# Random spot within fishing ripple area
	var rect = fishing_ripple_collision_shape_2d.shape.get_rect()
	
	var local_point := Vector2(randf_range(rect.position.x, rect.end.x),randf_range(rect.position.y, rect.end.y))
	
	# Convert from the CollisionShape2D's local space into world space
	var world_point := fishing_ripple_collision_shape_2d.to_global(local_point)
	
	# Instantiate fish ripple at world_point
	var new_fish_ripple := fishing_ripple_scene.instantiate() as FishRipple
	add_child(new_fish_ripple)
	new_fish_ripple.global_position = world_point
