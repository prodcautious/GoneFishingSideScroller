extends Node

var inventory: Array[Fish]
var MAX_INVENTORY_SIZE = 5

signal fish_added
signal fish_sold

func add_fish_to_inventory(fish: Fish) -> void:
	if inventory.size() >= MAX_INVENTORY_SIZE:
		print("No slots available! Inventory is full.")
		return
	var new_fish = fish.duplicate()
	inventory.append(new_fish)
	fish_added.emit()
	print("Added " + new_fish.get_type() + " (" + new_fish.get_weight() + "kg.)" + " to inventory. Price: " + str(new_fish.get_price()))

func sell_fish(fish: Fish) -> void:
	inventory.erase(fish)
	GameManager.increase_balance(fish.get_price())
	fish_sold.emit()
	print("Sold " + fish.get_type() + "( " + fish.get_weight() + "kg.)" + " for " + str(fish.get_price()))

func clear_inventory() -> void:
	inventory.clear()
