extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@export var npc_name: String
@export var shop_scene: PackedScene

@onready var detect_area_2d: Area2D = %DetectArea2D
@onready var name_label: Label = %NameLabel
@onready var interact_container: VBoxContainer = %InteractContainer

var player
var player_is_in_area: bool = false

func _ready() -> void:
	name_label.text = "[E] " + npc_name
	player = get_tree().get_first_node_in_group("Player")
	connect_signals()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && player_is_in_area:
		if player.current_player_state == player.PLAYER_STATE.FISHING || GameManager.in_shop_ui:
			return
		else:
			get_tree().paused = true
			DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

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

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	get_tree().paused = false
	var new_shop = shop_scene.instantiate()
	var canvas_layer = get_tree().get_first_node_in_group("UICanvas")
	canvas_layer.add_child(new_shop)
	GameManager.in_shop_ui = true
