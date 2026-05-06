extends CanvasLayer

@onready var animation_player: AnimationPlayer = %AnimationPlayer

signal transition_complete

var transitions = {
	"default": {
		"fade_in": "fade_default_in",
		"fade_out": "fade_default_out"
	},
	"swipe_vertical": {
		"fade_in": "fade_swipe_vertical_in",
		"fade_out": "fade_swipe_vertical_out"
	},
	"swipe_horizontal": {
		"fade_in": "fade_swipe_horizontal_in",
		"fade_out": "fade_swipe_horizontal_out"
	},
}

var current_transition: String

func _ready() -> void:
	randomize()

func transition_scene(scene: String, coords: Vector2 = Vector2.ZERO, facing_direction: float = 1.0) -> void:
	get_tree().paused = true
	randomize_current_transition()

	animation_player.play(transitions[current_transition]["fade_in"])
	await animation_player.animation_finished
	await get_tree().process_frame

	var traveling_player = get_tree().get_first_node_in_group("Player")
	if traveling_player:
		traveling_player.get_parent().remove_child(traveling_player)

	get_tree().change_scene_to_file(scene)
	await get_tree().process_frame

	var parent_node = get_tree().get_first_node_in_group("Area")
	
	if traveling_player:
		var baked_player = get_tree().get_first_node_in_group("Player")
		if baked_player:
			baked_player.queue_free()

		var characters_node = get_tree().get_first_node_in_group("Characters")
		if characters_node:
			characters_node.add_child(traveling_player)

		if coords != Vector2.ZERO:
			var coords_x = coords.x * 16
			var coords_y = coords.y * 16

			traveling_player.set_deferred("position", Vector2(coords_x, coords_y))

	await get_tree().process_frame
	
	if parent_node:
		parent_node.set_up_area()
		if traveling_player:
			traveling_player.face_direction(facing_direction)
			print("turning player around")

	await get_tree().create_timer(1.0).timeout
	
	animation_player.play(transitions[current_transition]["fade_out"])
	await animation_player.animation_finished
	await get_tree().process_frame

	get_tree().paused = false
	transition_complete.emit()

func randomize_current_transition() -> void:
	current_transition = transitions.keys().pick_random()
