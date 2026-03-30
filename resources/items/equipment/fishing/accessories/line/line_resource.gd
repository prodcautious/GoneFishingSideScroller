extends FishingAccessory
class_name Line

@export var type: String
@export var max_weight: float

#region Getters
func get_type() -> String:
	return type

func get_max_weight() -> float:
	return max_weight
#endregion

#region Setters
func set_type(new_type: String) -> void:
	type = new_type

func set_max_weight(new_max_weight: float) -> void:
	max_weight = new_max_weight
#endregion
