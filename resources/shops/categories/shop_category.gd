extends Resource
class_name ShopCategory

@export var category_name: String = ""
@export var items: Array[Item] = []

func get_category_name() -> String:
	return category_name

func get_items() -> Array:
	return items
