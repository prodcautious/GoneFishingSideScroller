extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@export var teleport_area_path: String
@export var spawn_coords: Vector2

@onready var detect_area_2d: Area2D = %DetectArea2D
@onready var name_label: Label = %NameLabel
@onready var interact_container: VBoxContainer = %InteractContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player
var player_is_in_area: bool = false
var is_teleporting: bool = false
var should_teleport: bool = false

func _ready() -> void:
	interact_container.hide()
	name_label.text = "[E] Teleport"
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("idle")
	connect_signals()

func _input(event: InputEvent) -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	if is_teleporting:
		return

	if player.current_player_state in [player.PLAYER_STATE.FISHING, player.PLAYER_STATE.INTERACTING]:
		return

	if event.is_action_pressed("interact") and player_is_in_area:
		should_teleport = false
		get_tree().paused = true
		player.set_state(2)
		interact_container.hide()

		DialogueManager.show_dialogue_balloon(dialogue_resource, "start", [self])

func request_teleport() -> void:
	should_teleport = true

func _on_detect_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player_is_in_area = true
		interact_container.show()

func _on_detect_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player_is_in_area = false
		interact_container.hide()

func connect_signals() -> void:
	detect_area_2d.area_entered.connect(_on_detect_area_entered)
	detect_area_2d.area_exited.connect(_on_detect_area_exited)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue_resource:
		return

	get_tree().paused = false
	player.set_state(0)

	if not should_teleport:
		return

	is_teleporting = true
	animation_player.play("teleport")
	await animation_player.animation_finished
	SceneTransition.transition_scene(teleport_area_path, spawn_coords)
