extends Node2D

@export_group("Camera Contraints")
@export var limit_left: int
@export var limit_right: int

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		player.camera_2d.limit_left = limit_left
		player.camera_2d.limit_right = limit_right

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
