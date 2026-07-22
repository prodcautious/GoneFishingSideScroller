extends Area2D

@export var scene_name: String

# Used to explicitly define the player's position AFTER transition. Leave empty for default editor position.
@export var transition_coords: Vector2

var player

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	player = area.get_parent()
	if player && player.is_in_group("Player"):
		player.lock()
		SceneTransition.transition_scene(scene_name, transition_coords)
