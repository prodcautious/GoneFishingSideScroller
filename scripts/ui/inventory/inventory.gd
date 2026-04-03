extends Control

@export var slot: PackedScene
@export var player: CharacterBody2D

@onready var inventory_container: HBoxContainer = %InventoryContainer
@onready var fishing_rod: Node2D = %FishingRod

func _ready() -> void:
	hide()
	InventoryManager.item_added.connect(update_inventory_slots)
	InventoryManager.item_sold.connect(update_inventory_slots)
	populate_inventory()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if GameManager.paused || GameManager.in_shop_ui || GameManager.controls_open:
			return
		get_viewport().set_input_as_handled()
		if player.current_player_state not in [player.PLAYER_STATE.FISHING, player.PLAYER_STATE.INTERACTING]:
			toggle_inventory()
	elif event.is_action_pressed("esc") && visible:
		get_viewport().set_input_as_handled()
		close_inventory()

func populate_inventory() -> void:
	if InventoryManager.inventory.size() > InventoryManager.MAX_INVENTORY_SIZE:
		InventoryManager.inventory.resize(InventoryManager.MAX_INVENTORY_SIZE)
		print("Inventory size exceeds max inventory size, resizing...")
	
	if slot:
		for i in InventoryManager.MAX_INVENTORY_SIZE:
			var item: Item = null
			if i < InventoryManager.inventory.size():
				item = InventoryManager.inventory[i]
			instantiate_new_slot(item)

func instantiate_new_slot(item: Item) -> void:
	var inventory_slot = slot.instantiate()
	inventory_container.add_child(inventory_slot)
	
	if item != null:
		var item_duplicate = item.duplicate()
		inventory_slot.item = item_duplicate
		inventory_slot.icon_texture_rect.texture = item_duplicate.icon
		inventory_slot.sell_button.disabled = true
		
func get_free_slots() -> int:
	var count: int = 0
	for inventory_slot in inventory_container.get_children():
		if inventory_slot.item != null:
			count += 1
	return count

func update_inventory_slots() -> void:
	var slots = inventory_container.get_children()
	for i in slots.size():
		if i < InventoryManager.inventory.size():
			slots[i].item = InventoryManager.inventory[i]
			slots[i].icon_texture_rect.texture = InventoryManager.inventory[i].get_icon()
			slots[i].desc_label.text = InventoryManager.inventory[i].get_type()
		else:
			slots[i].item = null
			slots[i].icon_texture_rect.texture = null
			slots[i].desc_label.text = ""

func open_inventory() -> void:
	show()
	GameManager.inventory_open = true
	get_tree().paused = true

func close_inventory() -> void:
	hide()
	GameManager.inventory_open = false
	get_tree().paused = false

func toggle_inventory() -> void:
	if visible:
		close_inventory()
	else:
		open_inventory()
