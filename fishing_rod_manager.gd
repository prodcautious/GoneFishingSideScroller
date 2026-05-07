extends Node

var fishing_rod : FishingRod = preload("res://resources/items/equipment/fishing/rods/default_rod.tres")

func _ready() -> void:
	fishing_rod.initialize_equipment()
