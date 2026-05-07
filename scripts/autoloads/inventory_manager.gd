extends Node

var inventory: Array[Fish]
var MAX_INVENTORY_SIZE = 5

signal item_added
signal item_sold

func add_inventory_item(item: Item) -> void:
	if InventoryManager.inventory.size() >= InventoryManager.MAX_INVENTORY_SIZE:
		print("No slots available! Inventory is full.")
		return
	var new_item = item.duplicate()
	InventoryManager.inventory.append(new_item)
	item_added.emit()
	print("Added " + new_item.get_type() + "( " + str(new_item.get_weight()) + "kg.)" + " to inventory. Price: " + str(new_item.get_price()))
	print(inventory)
