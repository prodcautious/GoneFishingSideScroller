extends Node2D

@export_group("Fishing Properties")
@export var can_fish: bool
@export var water_type: String

@export_group("Area Properties")
@export var song_name: String
@export var limit_left: int
@export var limit_right: int
@export var camera_zoom: Vector2 = Vector2(1,1)

var player

func _ready() -> void:
	AudioManager.play_music(song_name)

func set_up_area() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		push_warning("set_up_area: Player not found in scene.")
		return

	print("setting camera zoom to: " + str(camera_zoom))
	player.camera_2d.zoom = camera_zoom
	player.camera_2d.limit_left = limit_left
	player.camera_2d.limit_right = limit_right
