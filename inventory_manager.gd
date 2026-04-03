extends Node

var inventory: Array[Item]
var MAX_INVENTORY_SIZE = 5

signal item_added
signal item_sold

func add_inventory_item(item: Item) -> void:
	if InventoryManager.inventory.size() >= InventoryManager.MAX_INVENTORY_SIZE:
		print("No slots available! Inventory is full.")
		return
	var new_item = item.duplicate()
	new_item.set_price()
	InventoryManager.inventory.append(new_item)
	item_added.emit()
	print("Added " + new_item.get_type() + " to inventory.")
	print(inventory)
