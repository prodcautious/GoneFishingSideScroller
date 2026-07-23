extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@export var detect_area_size: Vector2
@export var voice: String

@onready var detect_area_2d: Area2D = %DetectArea2D
@onready var name_label: Label = %NameLabel
@onready var interact_container: VBoxContainer = %InteractContainer
@onready var detect_collision_shape_2d: CollisionShape2D = %DetectCollisionShape2D

var player
var player_is_in_area: bool = false
var cutscene_completed: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	if detect_area_size:
		detect_collision_shape_2d.shape.size = detect_area_size
		
	_connect_signals()

func _connect_signals() -> void:
	detect_area_2d.area_entered.connect(_on_detect_area_entered)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_detect_area_entered(area: Area2D) -> void:
	if cutscene_completed:
		return
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		get_tree().paused = true
		# Set state to Interacting
		DialogueManager.show_dialogue_balloon(dialogue_resource, "start", voice)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource == dialogue_resource:
		get_tree().paused = false
		# Back to Idle
		cutscene_completed = true
