extends FishingAccessory
class_name Bait

@export var count: int
@export var weight: float
@export var bite_detection_speed: float

#region Getters
func get_count() -> int:
	return count

func get_weight() -> float:
	return weight

func get_bite_detection_speed() -> float:
	return bite_detection_speed

func get_stats() -> String:
	return "Weight: " + str(get_weight())
#endregion

#region Setters
func set_count(new_count: int) -> void:
	count = new_count
	if count < 0:
		count = 0

func set_weight(new_weight: float) -> void:
	weight = new_weight

func set_bite_detection_speed(new_bite_detection_speed: float) -> void:
	bite_detection_speed = new_bite_detection_speed
#endregion
