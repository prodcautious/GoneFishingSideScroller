extends Node

var fish = {
	"Red Snapper": {
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.75,
		"catch_modifier": [],
		"weight": Vector2(0.5, 2.0),
		"base_price": 5,
		"texture": preload("res://assets/textures/items/fish/red_snapper.png"),
	},
	"Golden Trout": {
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.01,
		"catch_modifier": [],
		"weight": Vector2(1.0, 2.0),
		"base_price": 45,
		"texture": preload("res://assets/textures/items/fish/golden_snapper.png"),
	},
	"Happie": {
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.1,
		"catch_modifier": [],
		"weight": Vector2(2.0, 4.0),
		"base_price": 20,
		"texture": preload("res://assets/textures/items/fish/happie.png"),
	},
	"Marshmallow Fish": {
		"bait": ["Grub", "Debug Bait"],
		"water_type": ["Red Lake"],
		"catch_chance": 0.5,
		"catch_modifier": ["Campfire",],
		"weight": Vector2(0.5, 1.5),
		"base_price": 10,
		"texture": preload("res://assets/textures/items/fish/marshmallow_fish.png"),
	},
}

func _ready() -> void:
	randomize()
