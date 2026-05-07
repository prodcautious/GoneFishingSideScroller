extends FishingAccessory
class_name Bait

@export var count: int
@export var weight: float

#region Getters
func get_count() -> int:
	return count

func get_weight() -> float:
	return weight

func get_stats() -> String:
	return get_accessory_name() + "\n
	Count: " + str(get_count()) + "\n
	Weight: " + str(get_weight())
#endregion

#region Setters
func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0

func set_weight(new_weight: float) -> void:
	weight = new_weight
#endregion
