extends Node2D

@export_group("Area Limits")
@export var limit_left: int
@export var limit_right: int

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	set_up_area_limits(player)

func set_up_area_limits(player_node: Node) -> void:
	if player_node != null:
		player_node.camera_2d.limit_left = limit_left
		player_node.camera_2d.limit_right = limit_right
