extends Node2D

@export var dialogue_resource: DialogueResource

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	DialogueManager.show_dialogue_balloon(dialogue_resource)
