extends Node

var fish = {
	"Red Snapper": {
		"bait": ["Grub"],
		"catch_chance": 0.25,
		"weight": Vector2(0.5, 1.0),
		"base_price": 10,
		"texture": preload("res://assets/textures/items/fish/red_snapper.png"),
	},
	"Rainbow Trout": {
		"bait": ["Grub"],
		"catch_chance": 0.01,
		"weight": Vector2(0.5, 1.0),
		"base_price": 100,
		"texture": preload("res://assets/textures/items/fish/golden_snapper.png"),
	},
}

func _ready() -> void:
	randomize()

func get_fish_on_hook(bait_type: String) -> Fish:
	var eligible_fish = []
	for fish_name in fish:
		var fish_entry = fish[fish_name]
		if fish_entry["bait"].has(bait_type):
			eligible_fish.append({"name": fish_name, "data": fish_entry})

	if eligible_fish.is_empty():
		return null

	var total_catch_chance = 0.0
	for entry in eligible_fish:
		total_catch_chance += entry["data"]["catch_chance"]

	var roll = randf() * total_catch_chance
	var cumulative_chance = 0.0
	for entry in eligible_fish:
		cumulative_chance += entry["data"]["catch_chance"]
		if roll < cumulative_chance:
			return make_fish_resource(entry["name"], entry["data"])

	var fallback = eligible_fish.back()
	return make_fish_resource(fallback["name"], fallback["data"])

func make_fish_resource(fish_name: String, fish_data: Dictionary) -> Fish:
	var new_fish = Fish.new()
	new_fish.type = fish_name
	for bait in fish_data["bait"]:
		new_fish.required_bait.append(bait)
	new_fish.encounter_rate = fish_data["catch_chance"]
	new_fish.weight = randf_range(fish_data["weight"].x, fish_data["weight"].y)
	new_fish.base_price = fish_data["base_price"]
	new_fish.icon = fish_data["texture"]
	return new_fish
