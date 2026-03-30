extends FishingAccessory
class_name Bait

@export var type: String
@export var count: int
@export var weight: float

#region Getters
func get_type() -> String:
	return type

func get_count() -> int:
	return count

func get_weight() -> float:
	return weight
#endregion

#region Setters
func set_type(new_type: String) -> void:
	type = new_type

func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0

func set_weight(new_weight: float) -> void:
	weight = new_weight
#endregion
