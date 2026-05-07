extends Item
class_name Fish

@export var required_bait: Array[String]
@export var water_type: Array[String]
@export var encounter_rate: float
@export var weight: float
@export var base_price: int
@export var price: int = 0

func get_price() -> int:
	return price

func get_weight() -> String:
	var weight_to_hundredth = "%.2f" % weight
	return weight_to_hundredth + "kg."

func get_stats() -> String:
	return get_type() + "\n
	(" + get_weight() + ")" + "\n
	$" + str(get_price())
