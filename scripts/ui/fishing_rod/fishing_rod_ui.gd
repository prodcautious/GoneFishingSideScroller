extends Control
@export var rod: Node2D
@onready var name_label: Label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect
@onready var tooltip_label: Label = %TooltipLabel

var dialogue_active: bool = false

var fishing_rod
var fishing_rod_resource

func _ready() -> void:
	fishing_rod = get_tree().get_first_node_in_group("FishingRod")
	fishing_rod_resource = fishing_rod.rod_resource
	connect_signals()
	update_rod_ui()

func connect_signals() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_resource: DialogueResource) -> void:
	dialogue_active = true
	toggle_visibility()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	dialogue_active = false
	toggle_visibility()

func _process(_delta: float) -> void:
	toggle_visibility()

func toggle_visibility() -> void:
	visible = !visible

func update_rod_ui() -> void:
	if fishing_rod_resource != null:
		name_label.text = fishing_rod_resource.type
		texture_rect.texture = fishing_rod_resource.icon
		if fishing_rod.rod_equipped:
			tooltip_label.text = "Unequip"
		else:
			tooltip_label.text = "Equip"
