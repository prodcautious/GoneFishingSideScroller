extends Node

var has_fishing_rod: bool = false

var fishing_rod : FishingRod = preload("res://resources/items/equipment/fishing/rods/default_rod.tres")

func _ready() -> void:
	# Check if it exists, because when player starts it wont exist
	if fishing_rod:
		fishing_rod.initialize_equipment()
