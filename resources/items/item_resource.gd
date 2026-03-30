extends Resource
class_name Item

@export_group("Item Properties")
@export var type: String
@export var desc: String
@export var icon: Texture2D

#region Getters
func get_type() -> String:
	return type

func get_desc() -> String:
	return desc

func get_icon() -> Texture2D:
	return icon
#endregion

#region Setters
func set_type(new_type: String) -> void:
	type = new_type

func set_desc(new_desc: String) -> void:
	desc = new_desc

func set_icon(new_icon: Texture2D) -> void:
	icon = new_icon
#endregion
