extends Control

@export var slot: PackedScene

@onready var inventory_container: HBoxContainer = %InventoryContainer

var player

#region Built-In
func _ready() -> void:
	_grab_references()
	_register_to_menu_manager()
	_connect_signals()
	
	_populate_inventory()

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

#region Helpers
func _grab_references() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _register_to_menu_manager() -> void:
	MenuManager.register_menu(MenuManager.MenuState.INVENTORY, self)

func _connect_signals() -> void:
	InventoryManager.item_added.connect(_update_inventory_slots)

func _populate_inventory() -> void:
	if InventoryManager.inventory.size() > InventoryManager.MAX_INVENTORY_SIZE:
		InventoryManager.inventory.resize(InventoryManager.MAX_INVENTORY_SIZE)
		print("Inventory size exceeds max inventory size, resizing...")

	if slot:
		for i in InventoryManager.MAX_INVENTORY_SIZE:
			var fish: Fish = null
			if i < InventoryManager.inventory.size():
				fish = InventoryManager.inventory[i]
			_instantiate_new_slot(fish)

func _update_inventory_slots() -> void:
	var slots = inventory_container.get_children()

	for i in slots.size():
		if i < InventoryManager.inventory.size():
			slots[i].fish = InventoryManager.inventory[i]
			slots[i].set_up_slot()
		else:
			slots[i].reset_slot()

func _instantiate_new_slot(fish: Fish) -> void:
	var inventory_slot = slot.instantiate()
	inventory_container.add_child(inventory_slot)

	if fish:
		inventory_slot.fish = fish.duplicate()
		inventory_slot.set_up_slot()
	else:
		inventory_slot.reset_slot()

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
