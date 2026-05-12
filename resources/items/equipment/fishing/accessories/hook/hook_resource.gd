extends FishingAccessory
class_name Hook

@export var catch_rate: float
@export var count: int
@export var max_bait_weight: float
@export var weedless: bool = false

#region Getters
func get_catch_rate() -> float:
	return catch_rate

func get_count() -> int:
	return count

func get_max_bait_weight() -> float:
	return max_bait_weight

func get_stats() -> String:
	return "Catch rate: " + str(get_catch_rate() * 100) + "%\nMax Bait Weight: " + str(get_max_bait_weight())
#endregion

#region Setters
func set_catch_rate(new_catch_rate: float) -> void:
	catch_rate = new_catch_rate

func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0

func set_max_bait_weight(new_max_bait_weight: float) -> void:
	max_bait_weight = new_max_bait_weight
#endregion
