extends Item
class_name EquippableItem

@export_group("Equippable Item Properties")
@export var held_texture: Texture2D

func get_held_texture() -> Texture2D:
	return held_texture

func set_held_texture(new_held_texture: Texture2D) -> void:
	held_texture = new_held_texture
