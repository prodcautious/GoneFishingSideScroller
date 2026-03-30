extends Item
class_name Fish

@export var required_bait: Array[String]
@export var encounter_rate: float
@export var weight: float
@export var base_price: int
var price: int

func get_price() -> int:
	return price

func set_price() -> void:
	price = int(base_price * (weight + 1))
	print("Set fish price to ", str(price))

	
