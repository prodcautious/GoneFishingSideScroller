extends FishingAccessory
class_name Line

@export var max_weight: float

#region Getters
func get_max_weight() -> float:
	return max_weight

func get_stats(include_price: bool = false) -> String:
	if include_price:
		return get_type() + "\n
		Max Weight: " + str(get_max_weight()) + "\n
		$" + str(get_price())
	else:
		return get_type() + "\n
		Max Weight: " + str(get_max_weight())
#endregion

#region Setters
func set_max_weight(new_max_weight: float) -> void:
	max_weight = new_max_weight
#endregion
