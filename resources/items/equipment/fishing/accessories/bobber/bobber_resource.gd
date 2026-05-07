extends FishingAccessory
class_name Bobber

@export var overworld_texture: Texture2D
@export var bite_detection_speed_range: Vector2
@export var max_bait_weight: float

#region Getters
func get_overworld_texture() -> Texture2D:
	return overworld_texture

func get_bite_detection_speed() -> float:
	return randf_range(bite_detection_speed_range.x, bite_detection_speed_range.y)

func get_max_bait_weight() -> float:
	return max_bait_weight

func get_stats() -> String:
	return "Bite Detection Speed: " + str(bite_detection_speed_range) + "sec \n
	Max Bait Weight: " + str(get_max_bait_weight()) + "\n
	$" + str(get_price())
#endregion

#region Setters
func set_overworld_texture(new_overworld_texture: Texture2D) -> void:
	overworld_texture = new_overworld_texture

func set_bite_detection_speed(new_bite_detection_speed_range: Vector2) -> void:
	bite_detection_speed_range = new_bite_detection_speed_range

func set_max_bait_weight(new_max_bait_weight: float) -> void:
	max_bait_weight = new_max_bait_weight
#endregion
