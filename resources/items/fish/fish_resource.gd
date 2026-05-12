extends Item
class_name Fish

@export var accepted_bait: Array[String]
@export var water_type: Array[String]
@export var encounter_rate: float
@export var weight: float
@export var base_price: int
@export var price: int = 0

#region Getters
func get_accepted_bait() -> Array:
	return accepted_bait

func get_water_type() -> Array:
	return water_type

func get_encounter_rate() -> float:
	return encounter_rate

func get_weight() -> String:
	var padded_weight = str(weight).pad_decimals(2)
	return padded_weight

func get_base_price() -> int:
	return base_price

func get_price() -> int:
	return price

func get_stats() -> String:
	return "(" + get_weight() + "kg.)\n" + "$" + str(get_price())
#endregion

#region Setters
func set_accepted_bait(new_required_bait: String) -> void:
	if accepted_bait.has(new_required_bait):
		print(get_type() + " already has that accepted bait.") 
	else:
		accepted_bait.append(new_required_bait)
		print(new_required_bait + " has been added to the list of accepted bait for " + get_type() + ".") 

func set_water_type(new_water_type: String) -> void:
	if water_type.has(new_water_type):
		print(get_type() + " is already found in that water.") 
	else:
		water_type.append(new_water_type)
		print(new_water_type + " has been added to the list of water types for " + get_type() + ".") 

func set_encounter_rate(new_encounter_rate: float) -> void:
	encounter_rate = new_encounter_rate
	print(get_type() + " encounter rate has been set to " + str(encounter_rate) + ".")

func set_weight(new_weight: float) -> void:
	weight = new_weight
	print(get_type() + " weight rate has been set to " + str(weight) + ".")

func set_base_price(new_base_price: int) -> void:
	base_price = new_base_price
	print(get_type() + " base price has been set to " + str(base_price) + ".")

func set_price(new_price: int) -> void:
	price = new_price
	print(get_type() + " price has been set to " + str(price) + ".")
#endregion
