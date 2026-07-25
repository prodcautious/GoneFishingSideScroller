extends Node

var fish = {
	"red_snapper": {
		"name": "Red Snapper",
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.75,
		"catch_modifier": [],
		"weight": Vector2(0.5, 2.0),
		"price": Vector2(10,15),
		"texture": preload("res://assets/textures/items/fish/red_snapper.png"),
	},
	"golden_snapper": {
		"name": "Golden Snapper",
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.01,
		"catch_modifier": [],
		"weight": Vector2(1.0, 2.0),
		"price": Vector2(10,15),
		"texture": preload("res://assets/textures/items/fish/golden_snapper.png"),
	},
	"happie": {
		"name": "Happie",
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.1,
		"catch_modifier": [],
		"weight": Vector2(2.0, 4.0),
		"price": Vector2(10,15),
		"texture": preload("res://assets/textures/items/fish/happie.png"),
	},
	"marshmallow_fish": {
		"name": "Marshmallow Fish",
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.5,
		"catch_modifier": ["Campfire",],
		"weight": Vector2(0.5, 1.5),
		"price": Vector2(10,15),
		"texture": preload("res://assets/textures/items/fish/marshmallow_fish.png"),
	},
}

func _ready() -> void:
	randomize()

func make_fish_resource(fish_name: String, fish_data: Dictionary, cast_power: float, weight_bias: float, price_bias: float) -> Fish:
	var new_fish = Fish.new()
	new_fish.type = fish_name
	for water_type in fish_data["water_type"]:
		new_fish.water_type.append(water_type)
	for bait in fish_data["bait"]:
		if !new_fish.accepted_bait.has(bait):
			new_fish.accepted_bait.append(bait)
	new_fish.encounter_rate = fish_data["catch_chance"]
	
	var weight_range = fish_data["weight"]
	new_fish.weight_range = weight_range
	
	var base_weight := randf_range(fish_data["weight"].x, fish_data["weight"].y)
	new_fish.weight = lerp(base_weight, fish_data["weight"].y, cast_power * weight_bias)
	
	var price_range = fish_data["price"]
	new_fish.price_range = price_range
	
	var base_price = randi_range(fish_data["price"].x, fish_data["price"].y)
	new_fish.price = int(base_price) * lerp(1.0, 1.0 + price_bias, cast_power)

	new_fish.icon = fish_data["texture"]
	return new_fish
