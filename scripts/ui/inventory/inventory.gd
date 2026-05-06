extends Control

@export var slot: PackedScene

@onready var inventory_container: HBoxContainer = %InventoryContainer

var player

#region Built-In
func _ready() -> void:
	_grab_references()
	_register_to_menu_manager()
	_connect_signals()
	
	populate_inventory()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		get_viewport().set_input_as_handled()
		
		if !player:
			_grab_references()
		
		if get_tree().paused:
			return

		if MenuManager.is_menu_open() and not MenuManager.is_open(MenuManager.MenuState.INVENTORY):
			return

		if player && player.current_player_state in [player.PLAYER_STATE.FISHING, player.PLAYER_STATE.INTERACTING]:
			return

		_toggle_inventory()

	elif event.is_action_pressed("esc") && visible:
		get_viewport().set_input_as_handled()
		_close_inventory()
#endregion

#region Inventory Population/Updating
func populate_inventory() -> void:
	if InventoryManager.inventory.size() > InventoryManager.MAX_INVENTORY_SIZE:
		InventoryManager.inventory.resize(InventoryManager.MAX_INVENTORY_SIZE)
		print("Inventory size exceeds max inventory size, resizing...")

	if slot:
		for i in InventoryManager.MAX_INVENTORY_SIZE:
			var item: Item = null
			if i < InventoryManager.inventory.size():
				item = InventoryManager.inventory[i]
			_instantiate_new_slot(item)

func update_inventory_slots() -> void:
	var slots = inventory_container.get_children()
	for i in slots.size():
		if i < InventoryManager.inventory.size():
			var current_inventory_index = InventoryManager.inventory[i]
			slots[i].item = current_inventory_index
			slots[i].icon_texture_rect.texture = current_inventory_index.get_icon()
			slots[i].desc_label.text = current_inventory_index.get_type() + "\n" + "(" + current_inventory_index.get_weight() + ")"
			await get_tree().process_frame
			slots[i].sell_button.text = "$" + str(slots[i].item.get_price())
		else:
			slots[i].item = null
			slots[i].icon_texture_rect.texture = null
			slots[i].desc_label.text = ""

func _instantiate_new_slot(item: Item) -> void:
	var inventory_slot = slot.instantiate()
	inventory_container.add_child(inventory_slot)
	
	if item != null:
		var item_duplicate = item.duplicate()
		inventory_slot.item = item_duplicate
		inventory_slot.icon_texture_rect.texture = item_duplicate.icon
		inventory_slot.sell_button.disabled = true
#endregion

#region Helpers
func _grab_references() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _register_to_menu_manager() -> void:
	MenuManager.register_menu(MenuManager.MenuState.INVENTORY, self)

func _connect_signals() -> void:
	InventoryManager.item_added.connect(update_inventory_slots)
	InventoryManager.item_sold.connect(update_inventory_slots)
#endregion

#region Inventory Toggle Helpers
func _open_inventory() -> void:
	MenuManager.show_menu(MenuManager.MenuState.INVENTORY)

func _close_inventory() -> void:
	MenuManager.close_current_menu()

func _toggle_inventory() -> void:
	if MenuManager.is_open(MenuManager.MenuState.INVENTORY):
		_close_inventory()
	else:
		_open_inventory()
#endregion
