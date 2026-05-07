extends Control

enum SlotMode {
	EQUIPPED,
	SELECTION
}

@onready var accessory_button: CustomButton = %AccessoryButton
@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var desc_panel_container: PanelContainer = %DescPanelContainer
@onready var accessory_stats: Label = %AccessoryStats

var accessory: FishingAccessory
var slot_mode: SlotMode = SlotMode.EQUIPPED
var equipped: bool = false

signal equipped_slot_pressed(accessory: FishingAccessory)
signal selection_slot_pressed(accessory: FishingAccessory)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	accessory_button.mouse_entered.connect(_on_accessory_button_mouse_entered)
	accessory_button.mouse_exited.connect(_on_accessory_button_mouse_exited)
	accessory_button.pressed.connect(_on_accessory_button_pressed)

func set_up_slot(new_accessory: FishingAccessory, new_mode: SlotMode, is_equipped: bool = false) -> void:
	accessory = new_accessory
	slot_mode = new_mode
	equipped = is_equipped

	if accessory == null:
		reset_slot()
		return

	icon_texture_rect.texture = accessory.get_icon()
	accessory_stats.text = accessory.get_stats()

	update_equipped_visual()

func update_equipped_visual() -> void:
	if equipped:
		modulate = Color(1.3, 1.3, 1.3)
	else:
		modulate = Color.WHITE

func reset_slot() -> void:
	icon_texture_rect.texture = null
	accessory_stats.text = ""
	accessory = null
	equipped = false
	desc_panel_container.hide()
	update_equipped_visual()

func _on_accessory_button_mouse_entered() -> void:
	if accessory:
		desc_panel_container.show()

func _on_accessory_button_mouse_exited() -> void:
	if accessory:
		desc_panel_container.hide()

func _on_accessory_button_pressed() -> void:
	if accessory == null:
		return

	match slot_mode:
		SlotMode.EQUIPPED:
			equipped_slot_pressed.emit(accessory)

		SlotMode.SELECTION:
			selection_slot_pressed.emit(accessory)
