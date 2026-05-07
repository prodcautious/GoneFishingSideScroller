extends EquippableItem
class_name FishingRod

@export_group("Accessories")
@export var hook: Hook
@export var bobber: Bobber
@export var bait: Bait
@export var line: Line

@export_group("Properties")
@export var durability: int = 100

var catch_modifier: String

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

func get_catch_modifier() -> String:
	return catch_modifier
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

func set_catch_modifier(new_catch_modifier) -> void:
	catch_modifier = new_catch_modifier
#endregion

func is_missing_equipment() -> bool:
	var current_bait = get_bait()
	var current_hook = get_hook()
	
	if !current_bait.get_count() <= 0 || !current_hook.get_count() <= 0:
		return false
	else:
		return true
