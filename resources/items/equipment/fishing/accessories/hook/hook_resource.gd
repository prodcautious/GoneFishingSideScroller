extends FishingAccessory
class_name Hook

@export var catch_rate: float
@export var count: int
@export var weedless: bool = false

#region Getters
func get_catch_rate() -> float:
	return catch_rate

func get_count() -> int:
	return count

func get_stats(include_price: bool = false) -> String:
	if include_price:
		return get_type() + "\n
		Catch rate: " + str(get_catch_rate() * 100) + "%\n
		Count: " + str(get_count()) + "\n
		$" + str(get_price())
	else:
		return get_type() + "\n
		Catch rate: " + str(get_catch_rate() * 100) + "%\n
		Count: " + str(get_count())
#endregion

#region Setters
func set_catch_rate(new_catch_rate: float) -> void:
	catch_rate = new_catch_rate

func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0
#endregion
