extends FishingAccessory
class_name Bobber

@export var type: String
@export var bite_detection_speed_range: Vector2
@export var max_bait_weight: float

#region Getters
func get_type() -> String:
	return type

func get_bite_detection_speed() -> float:
	return randf_range(bite_detection_speed_range.x, bite_detection_speed_range.y)

func get_max_bait_weight() -> float:
	return max_bait_weight
#endregion

#region Setters
func set_type(new_type: String) -> void:
	type = new_type

func set_bite_detection_speed(new_bite_detection_speed_range: Vector2) -> void:
	bite_detection_speed_range = new_bite_detection_speed_range

func set_max_bait_weight(new_max_bait_weight: float) -> void:
	max_bait_weight = new_max_bait_weight
#endregion
