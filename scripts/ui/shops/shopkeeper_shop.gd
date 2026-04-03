extends Control

@export var shopkeeper_slot: PackedScene
@export var inventory_slot: PackedScene

@onready var shop_item_grid_container: GridContainer = %ShopItemGridContainer
@onready var inventory_grid_container: GridContainer = %InventoryGridContainer

var player

func _ready() -> void:
	await get_tree().process_frame
	populate_inventory_grid()

func populate_inventory_grid() -> void:
	for i in InventoryManager.MAX_INVENTORY_SIZE:
		var item: Item = null
		if i < InventoryManager.inventory.size():
			item = InventoryManager.inventory[i]
		instantiate_new_slot(item)

func instantiate_new_slot(item: Item) -> void:
	var new_slot = inventory_slot.instantiate()
	inventory_grid_container.add_child(new_slot)
	if item != null:
		new_slot.item = item
		new_slot.icon_texture_rect.texture = item.get_icon()
		new_slot.sell_button.disabled = false
		new_slot.sell_button.text = "Sell (" + str(item.get_price()) + ")"

		new_slot.desc_label.text = item.get_type()
		new_slot.can_sell = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		queue_free()
		GameManager.in_shop_ui = false
