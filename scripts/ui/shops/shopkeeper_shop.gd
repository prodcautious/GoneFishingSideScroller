extends Control

@export var inventory_slot: PackedScene
@export var shop_slot: PackedScene

@onready var buy_shop_label: Label = %BuyShopLabel
@onready var sell_shop_label: Label = %SellShopLabel
@onready var inventory_container: HBoxContainer = %InventoryContainer
@onready var shop_v_box_container: VBoxContainer = %ShopVBoxContainer
@onready var tooltip_layer: Control = %TooltipLayer

var shop : Shop

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	tooltip_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	MenuManager.register_menu(MenuManager.MenuState.SHOP, self)

	hide()

	await get_tree().process_frame
	_populate_shop()
	_populate_inventory()

func _populate_inventory() -> void:
	if inventory_slot == null:
		return

	for i in InventoryManager.MAX_INVENTORY_SIZE:
		var fish: Fish = null

		if i < InventoryManager.inventory.size():
			fish = InventoryManager.inventory[i]

		_instantiate_new_slot(fish)

func _populate_shop() -> void:
	if !shop:
		return
	
	for category in shop.categories:
		var label := Label.new()
		var scroll_container := ScrollContainer.new()
		var h_box_container := HBoxContainer.new()
		shop_v_box_container.add_child(label)
		label.text = category.get_category_name()
		shop_v_box_container.add_child(scroll_container)
		scroll_container.custom_minimum_size.y = 96
		scroll_container.clip_contents = false
		scroll_container.add_child(h_box_container)
		h_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
		h_box_container.custom_minimum_size.y = 96
		for item in category.items:
			var new_shop_slot = shop_slot.instantiate()
			h_box_container.add_child(new_shop_slot)
			new_shop_slot.set_up_slot(item)
			new_shop_slot.tooltip_layer = tooltip_layer

func _update_inventory_slots() -> void:
	var slots = inventory_container.get_children()

	for i in slots.size():
		if i < InventoryManager.inventory.size():
			slots[i].fish = InventoryManager.inventory[i]
			slots[i].set_up_slot(true)
		else:
			slots[i].reset_slot()

func _instantiate_new_slot(fish: Fish) -> void:
	var new_slot = inventory_slot.instantiate()
	inventory_container.add_child(new_slot)

	if fish:
		new_slot.fish = fish
		new_slot.set_up_slot(true)
	else:
		new_slot.reset_slot()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and visible:
		get_viewport().set_input_as_handled()
		MenuManager.close_current_menu()
		queue_free()
