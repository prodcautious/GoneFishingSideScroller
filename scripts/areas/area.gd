extends Node2D

@export_group("Fishing Properties")
@export var can_fish: bool
@export var water_type: String
@export var fishing_ripple_scene: PackedScene


@export_group("Area Properties")
@export var song_name: String
@export var limit_left: int
@export var limit_right: int
@export var camera_zoom: Vector2 = Vector2(2,2)

@onready var fishing_ripple_collision_shape_2d: CollisionShape2D = %FishingRippleCollisionShape2D
@onready var fish_ripple_timer: Timer = %FishRippleTimer

var player

func _ready() -> void:
	if can_fish:
		fish_ripple_timer.wait_time = randf_range(5.0, 15.0)
		fish_ripple_timer.start()
		fish_ripple_timer.timeout.connect(_on_fish_ripple_timer_timeout)
	set_up_area()

func set_up_area() -> void:
	if song_name:
		AudioManager.play_song(song_name)

	player = get_tree().get_first_node_in_group("Player")
	
	if player == null:
		push_warning("Player not found in scene.")
		return

	if limit_left:
		player.camera_2d.limit_left = limit_left
	
	if limit_right:
		player.camera_2d.limit_right = limit_right

	# Defaults to a 2x zoom or whatever it's changed to in export
	player.camera_2d.zoom = camera_zoom

func _on_fish_ripple_timer_timeout() -> void:
	spawn_fish_ripple()
	fish_ripple_timer.wait_time = randf_range(5.0, 15.0)
	fish_ripple_timer.start()

func spawn_fish_ripple() -> void:
	# Random spot within fishing ripple area
	var rect = fishing_ripple_collision_shape_2d.shape.get_rect()
	
	var local_point := Vector2(
		randf_range(rect.position.x, rect.end.x),
		randf_range(rect.position.y, rect.end.y)
	)
	
	# Convert from the CollisionShape2D's local space into world space
	var world_point := fishing_ripple_collision_shape_2d.to_global(local_point)
	
	# Instantiate fish ripple at world_point
	var new_fish_ripple := fishing_ripple_scene.instantiate() as FishRipple
	add_child(new_fish_ripple)
	new_fish_ripple.global_position = world_point
