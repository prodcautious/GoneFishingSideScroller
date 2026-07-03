extends Node

signal fishing_rod_changed(rod: FishingRod)

var debug_fishing_rod: FishingRod = preload("res://resources/items/equipment/fishing/rods/default_rod.tres")

var fishing_rod: FishingRod = null

func _ready() -> void:
	if GameManager.debug:
		set_fishing_rod(debug_fishing_rod)

func set_fishing_rod(rod: FishingRod) -> void:
	if rod == null:
		push_warning("Tried to set a null fishing rod.")
		return

	fishing_rod = rod.duplicate(true)
	fishing_rod.initialize_equipment()

	fishing_rod_changed.emit(fishing_rod)

func has_fishing_rod() -> bool:
	return fishing_rod != null
