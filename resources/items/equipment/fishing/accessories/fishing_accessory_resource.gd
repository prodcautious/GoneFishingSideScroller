extends Item
class_name FishingAccessory

enum AccessoryType {
	BAIT,
	HOOK,
	LINE
}

@export var accessory_type: AccessoryType
@export_multiline var stats: String

func get_stats() -> String:
	return stats

func get_accessory_type() -> AccessoryType:
	return accessory_type
