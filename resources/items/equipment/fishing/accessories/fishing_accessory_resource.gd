extends Resource
class_name FishingAccessory

enum AccessoryType {
	BAIT,
	BOBBER,
	HOOK,
	LINE
}

@export var accessory_type: AccessoryType
@export var accessory_name: String
@export var icon: Texture2D
@export_multiline var stats: String

func get_type() -> AccessoryType:
	return accessory_type

func get_accessory_name() -> String:
	return accessory_name

func get_icon() -> Texture2D:
	return icon

func get_stats() -> String:
	return stats
