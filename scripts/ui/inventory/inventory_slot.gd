extends Control

@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var item_type: RichTextLabel = %ItemType
@onready var item_stats: RichTextLabel = %ItemStats
@onready var item_button: Button = %ItemButton
@onready var desc_panel_container: PanelContainer = %DescPanelContainer

var fish: Fish

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

func set_up_slot() -> void:
	if fish:
		icon_texture_rect.texture = fish.get_icon()
		item_type.text = fish.get_type()
		item_stats.text = fish.get_stats()
	else:
		reset_slot()

func reset_slot() -> void:
	icon_texture_rect.texture = null
	item_stats.text = ""
	fish = null
	desc_panel_container.hide()
#endregion

#region Signals
func _on_item_button_mouse_entered() -> void:
	if fish:
		desc_panel_container.show()

func _on_item_button_mouse_exited() -> void:
	if fish:
		desc_panel_container.hide()

func _on_item_button_pressed() -> void:
	if fish:
		InventoryManager.sell_fish(fish)
		reset_slot()
#endregion
