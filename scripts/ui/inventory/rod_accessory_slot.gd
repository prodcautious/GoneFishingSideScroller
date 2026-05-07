extends Control

@onready var accessory_button: CustomButton = %AccessoryButton
@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var desc_panel_container: PanelContainer = %DescPanelContainer
@onready var accessory_stats: Label = %AccessoryStats

var accessory: FishingAccessory

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	accessory_button.mouse_entered.connect(_on_accessory_button_mouse_entered)
	accessory_button.mouse_exited.connect(_on_accessory_button_mouse_exited)

func set_up_slot() -> void:
	if accessory:
		icon_texture_rect.texture = accessory.get_icon()
		accessory_stats.text = accessory.get_stats()
	else:
		reset_slot()

func reset_slot() -> void:
	icon_texture_rect.texture = null
	accessory_stats.text = ""
	accessory = null
	desc_panel_container.hide()

func _on_accessory_button_mouse_entered() -> void:
	if accessory:
		desc_panel_container.show()

func _on_accessory_button_mouse_exited() -> void:
	if accessory:
		desc_panel_container.hide()
