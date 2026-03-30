extends Control

@export var rod: Node2D

@onready var name_label: Label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect
@onready var tooltip_label: Label = %TooltipLabel

func _ready() -> void:
	connect_signals()
	update_rod_ui()

func connect_signals() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_resource: DialogueResource) -> void:
	hide()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	show()

func _process(_delta: float) -> void:
	if GameManager.in_shop_ui && visible:
		hide()
		return
	elif !GameManager.in_shop_ui && !visible:
		show()
		return

func update_rod_ui() -> void:
	var fishing_rod_resource = rod.rod_resource
	if fishing_rod_resource != null:
		name_label.text = fishing_rod_resource.type
		texture_rect.texture = fishing_rod_resource.icon
		if rod.rod_equipped:
			tooltip_label.text = "Unequip"
		else:
			tooltip_label.text = "Equip"
