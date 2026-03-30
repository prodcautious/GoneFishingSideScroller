extends Control

@export var shopkeeper_slot: PackedScene
@export var inventory_slot: PackedScene

@onready var shop_item_grid_container: GridContainer = %ShopItemGridContainer
@onready var inventory_grid_container: GridContainer = %InventoryGridContainer

var inventory_node
var MAX_INVENTORY_SIZE
var player

func _ready() -> void:
	await get_tree().process_frame
	inventory_node = get_tree().get_first_node_in_group("Inventory")
	MAX_INVENTORY_SIZE = inventory_node.MAX_INVENTORY_SIZE
	populate_inventory_grid()

func populate_inventory_grid() -> void:
	for i in MAX_INVENTORY_SIZE:
		var item: Item = null
		if i < inventory_node.inventory.size():
			item = inventory_node.inventory[i]
		instantiate_new_slot(item)

func instantiate_new_slot(item: Item) -> void:
	var new_slot = inventory_slot.instantiate()
	inventory_grid_container.add_child(new_slot)
	if item != null:
		new_slot.item = item
		new_slot.icon_texture_rect.texture = item.get_icon()
		new_slot.desc_label.text = item.get_type() + " (" + str(item.get_price()) + ")"
		new_slot.can_sell = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		queue_free()
		GameManager.in_shop_ui = false
