extends EquippableItem
class_name FishingRod

@export_group("Accessories")
@export var bait_array: Array[Bait]
@export var hook_array: Array[Hook]
@export var line_array: Array[Line]

var current_bait: Bait
var current_hook: Hook
var current_line: Line

var catch_modifier: String

signal equipment_changed

func initialize_equipment() -> void:
	if bait_array.size() > 0:
		current_bait = bait_array[0]

	if hook_array.size() > 0:
		current_hook = hook_array[0]

	if line_array.size() > 0:
		current_line = line_array[0]

func equip_accessory(accessory: FishingAccessory) -> void:
	if accessory == null:
		return

	match accessory.get_accessory_type():
		FishingAccessory.AccessoryType.BAIT:
			if bait_array.has(accessory):
				current_bait = accessory

		FishingAccessory.AccessoryType.HOOK:
			if hook_array.has(accessory):
				current_hook = accessory

		FishingAccessory.AccessoryType.LINE:
			if line_array.has(accessory):
				current_line = accessory

#region Getters
func get_hooks() -> Array:
	return hook_array

func get_current_hook() -> Hook:
	return current_hook

func get_bait() -> Array:
	return bait_array

func get_current_bait() -> Bait:
	return current_bait

func get_lines() -> Array:
	return line_array
	
func get_current_line() -> Line:
	return current_line

func get_accessories_by_type(accessory_type: FishingAccessory.AccessoryType) -> Array:
	match accessory_type:
		FishingAccessory.AccessoryType.BAIT:
			return bait_array

		FishingAccessory.AccessoryType.HOOK:
			return hook_array

		FishingAccessory.AccessoryType.LINE:
			return line_array

		_:
			return []

func get_current_accessory_by_type(accessory_type: FishingAccessory.AccessoryType) -> FishingAccessory:
	match accessory_type:
		FishingAccessory.AccessoryType.BAIT:
			return current_bait

		FishingAccessory.AccessoryType.HOOK:
			return current_hook

		FishingAccessory.AccessoryType.LINE:
			return current_line

		_:
			return null

func consume_bait_and_hook() -> void:
	_consume_accessory(current_bait, bait_array, FishingAccessory.AccessoryType.BAIT)
	_consume_accessory(current_hook, hook_array, FishingAccessory.AccessoryType.HOOK)

	equipment_changed.emit()

func _consume_accessory(
	accessory: FishingAccessory,
	accessory_array: Array,
	accessory_type: FishingAccessory.AccessoryType
) -> void:
	if accessory == null:
		_equip_next_available(accessory_type)
		return

	accessory.set_count(accessory.get_count() - 1)

	if accessory.get_count() <= 0:
		accessory_array.erase(accessory)
		_equip_next_available(accessory_type)
	
func _equip_next_available(accessory_type: FishingAccessory.AccessoryType) -> void:
	var accessories := get_accessories_by_type(accessory_type)

	var next_accessory: FishingAccessory = null

	for accessory in accessories:
		if accessory != null and accessory.get_count() > 0:
			next_accessory = accessory
			break

	match type:
		FishingAccessory.AccessoryType.BAIT:
			current_bait = next_accessory

		FishingAccessory.AccessoryType.HOOK:
			current_hook = next_accessory

		FishingAccessory.AccessoryType.LINE:
			current_line = next_accessory

func get_catch_modifier() -> String:
	return catch_modifier
#endregion

#region Setters
func set_current_bait(bait: Bait) -> void:
	if bait_array.has(bait):
		current_bait = bait

func set_current_hook(hook: Hook) -> void:
	if hook_array.has(hook):
		current_hook = hook

func set_current_line(line: Line) -> void:
	if line_array.has(line):
		current_line = line

func set_catch_modifier(new_catch_modifier) -> void:
	catch_modifier = new_catch_modifier
#endregion

func is_missing_equipment() -> bool:
	if current_bait == null or current_bait.get_count() <= 0:
		if current_bait != null:
			bait_array.erase(current_bait)

		current_bait = bait_array[0] if bait_array.size() > 0 else null

	if current_hook == null or current_hook.get_count() <= 0:
		if current_hook != null:
			hook_array.erase(current_hook)

		current_hook = hook_array[0] if hook_array.size() > 0 else null

	return current_bait == null or current_hook == null
