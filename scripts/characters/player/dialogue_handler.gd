extends Node2D

var player
var tween : Tween
var current_npc: CharacterBody2D

var current_camera_zoom: Vector2

@onready var interact_vignette: ColorRect = %InteractVignette
@onready var interact_area_2d: Area2D = %InteractArea2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	_connect_signals()
	
func _connect_signals() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	interact_area_2d.area_entered.connect(_on_interact_area_entered)
	interact_area_2d.area_exited.connect(_on_interact_area_exited)
	
func _on_dialogue_started(_resource: DialogueResource) -> void:
	print("player: ", player)
	print("camera: ", player.camera_2d)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)

	player = get_tree().get_first_node_in_group("Player")
	current_camera_zoom = player.camera_2d.zoom
	
	print("Current Camera Zoom: " + str(current_camera_zoom))
	tween.tween_property(player.camera_2d, "zoom", current_camera_zoom * 1.5, 0.2)
	if current_npc:
		var offset_to_npc = (current_npc.global_position - player.global_position)
		tween.tween_property(player.camera_2d, "offset", offset_to_npc, 0.2)
	
	interact_vignette.show()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	if tween:
		tween.kill()
	print("zooming camera")
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(player.camera_2d, "zoom", current_camera_zoom, 0.2)
	tween.tween_property(player.camera_2d, "offset", Vector2.ZERO, 0.2)
	interact_vignette.hide()

func _on_interact_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("NPC"):
		current_npc = area.get_parent()

func _on_interact_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("NPC"):
		current_npc = null
