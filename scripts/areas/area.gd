extends Node2D

@export_group("Fishing Properties")
@export var can_fish: bool
@export var water_type: String

@export_group("Area Properties")
@export var song_name: String
@export var limit_left: int
@export var limit_right: int
@export var camera_zoom: Vector2 = Vector2(2,2)

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		SceneTransition.transition_complete.connect(player.unlock, CONNECT_ONE_SHOT)
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
