extends FishingAccessory
class_name Line

@export var max_weight: float

#region Getters
func get_max_weight() -> float:
	return max_weight

func get_stats() -> String:
	return get_accessory_name() + "\n
	Max Weight: " + str(get_max_weight())
#endregion

#region Setters
func set_max_weight(new_max_weight: float) -> void:
	max_weight = new_max_weight
#endregion
