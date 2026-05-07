extends Control

@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var item_stats: Label = %ItemStats
@onready var item_button: Button = %ItemButton
@onready var desc_panel_container: PanelContainer = %DescPanelContainer

@export var accessory: FishingAccessory
var tooltip_layer: Control

#region Built-In
func _ready() -> void:
	await get_tree().process_frame
	_connect_signals()
#endregion

#region Helpers
func _connect_signals() -> void:
	item_button.mouse_entered.connect(_on_item_button_mouse_entered)
	item_button.mouse_exited.connect(_on_item_button_mouse_exited)
	item_button.pressed.connect(_on_item_button_pressed)

func set_up_slot(new_accessory: Item) -> void:
	accessory = new_accessory
	icon_texture_rect.texture = accessory.get_icon()
	item_stats.text = accessory.get_stats()
#endregion

#region Signals
func _on_item_button_mouse_entered() -> void:
	desc_panel_container.reparent(tooltip_layer)
	desc_panel_container.global_position = item_button.global_position + Vector2(0, -desc_panel_container.size.y - 8)
	desc_panel_container.show()
	desc_panel_container.z_index = 999

func _on_item_button_mouse_exited() -> void:
	desc_panel_container.hide()

func _on_item_button_pressed() -> void:
	if GameManager.balance >= accessory.get_price():
		GameManager.decrease_balance(accessory.get_price())
#endregion
