extends CanvasLayer

@onready var animation_player: AnimationPlayer = %AnimationPlayer

signal transition_complete

var transitions = {
	"default":
		{
			"fade_in": "fade_default_in",
			"fade_out": "fade_default_out"
		},
	"swipe_vertical":
		{
			"fade_in": "fade_swipe_vertical_in",
			"fade_out": "fade_swipe_vertical_out"
		},
	"swipe_horizontal":
		{
			"fade_in": "fade_swipe_horizontal_in",
			"fade_out": "fade_swipe_horizontal_out"
		},
}

var current_transition

#region Custom Functions
func _ready() -> void:
	randomize()

func transition_scene(scene: String, coords: Vector2 = Vector2.ZERO) -> void:
	get_tree().paused = true
	#AudioManager.fade_out_audio(0.5)
	randomize_current_transition()
	animation_player.play(transitions[current_transition]["fade_in"])
	await animation_player.animation_finished

	get_tree().change_scene_to_file(scene)
	await get_tree().process_frame

	var player = get_tree().get_first_node_in_group("Player")
	if coords != Vector2.ZERO and player != null:
		player.position = coords

	await get_tree().create_timer(1.0).timeout
	#AudioManager.fade_in_audio(0.5)
	animation_player.play(transitions[current_transition]["fade_out"])
	await animation_player.animation_finished
	get_tree().paused = false
	transition_complete.emit()

func randomize_current_transition():
	current_transition = transitions.keys().pick_random()
#endregion
