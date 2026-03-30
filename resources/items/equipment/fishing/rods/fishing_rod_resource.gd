extends EquippableItem
class_name FishingRod

@export_group("Accessories")
@export var hook: Hook
@export var bobber: Bobber
@export var bait: Bait
@export var line: Line

@export_group("Properties")
@export var durability: int = 100

#region Getters
func get_hook() -> Hook:
	return hook

func get_bobber() -> Bobber:
	return bobber

func get_bait() -> Bait:
	return bait

func get_line() -> Line:
	return line

func get_durability() -> int:
	return durability
#endregion

#region Setters
func set_hook(new_hook: Hook) -> void:
	hook = new_hook

func set_bobber(new_bobber: Bobber) -> void:
	bobber = new_bobber

func set_bait(new_bait: Bait) -> void:
	bait = new_bait

func set_line(new_line: Line) -> void:
	line = new_line

func set_durability(new_durability: int) -> void:
	durability = new_durability
#endregion
