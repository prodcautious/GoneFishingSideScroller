extends FishingAccessory
class_name Hook

@export var type: String
@export var catch_rate: float
@export var count: int
@export var weedless: bool = false

#region Getters
func get_type() -> String:
	return type

func get_catch_rate() -> float:
	return catch_rate

func get_count() -> int:
	return count
#endregion

#region Setters
func set_type(new_type: String) -> void:
	type = new_type

func set_catch_rate(new_catch_rate: float) -> void:
	catch_rate = new_catch_rate

func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0
#endregion
