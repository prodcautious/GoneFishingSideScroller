extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		player.camera_2d.limit_left = -320
		player.camera_2d.limit_right = 320


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
