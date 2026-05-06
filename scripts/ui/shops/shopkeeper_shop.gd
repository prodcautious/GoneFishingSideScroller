extends Control

@export var shopkeeper_slot: PackedScene
@export var inventory_slot: PackedScene
@onready var buy_shop_label: Label = %BuyShopLabel
@onready var sell_shop_label: Label = %SellShopLabel

@onready var inventory_container: HBoxContainer = %InventoryContainer

var player

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	MenuManager.register_menu(MenuManager.MenuState.SHOP, self)
	MenuManager.show_menu(MenuManager.MenuState.SHOP)
	
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
	inventory_container.add_child(new_slot)
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
		MenuManager.close_current_menu()
		queue_free()
