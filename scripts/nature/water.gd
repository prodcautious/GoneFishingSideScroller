extends Sprite2D

@export var player: Node2D

func _process(_delta):
	if player:
		var viewport_size = get_viewport().get_visible_rect().size
		var camera = get_viewport().get_camera_2d()
		var screen_center = camera.get_screen_center_position()
		var player_screen = (player.global_position - screen_center) / viewport_size + Vector2(0.5, 0.5)
		material.set_shader_parameter("player_pos", player_screen)
