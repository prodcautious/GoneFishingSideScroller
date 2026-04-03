extends Control
@export var rod: Node2D
@onready var name_label: Label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect
@onready var tooltip_label: Label = %TooltipLabel

var dialogue_active: bool = false

func _ready() -> void:
	connect_signals()
	update_rod_ui()

func connect_signals() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_resource: DialogueResource) -> void:
	dialogue_active = true
	update_visibility()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	dialogue_active = false
	update_visibility()

func _process(_delta: float) -> void:
	update_visibility()

func update_visibility() -> void:
	var should_be_visible = !GameManager.paused && !GameManager.in_shop_ui && !dialogue_active && !GameManager.inventory_open
	if visible != should_be_visible:
		visible = should_be_visible

func update_rod_ui() -> void:
	var fishing_rod_resource = rod.rod_resource
	if fishing_rod_resource != null:
		name_label.text = fishing_rod_resource.type
		texture_rect.texture = fishing_rod_resource.icon
		if rod.rod_equipped:
			tooltip_label.text = "Unequip"
		else:
			tooltip_label.text = "Equip"
