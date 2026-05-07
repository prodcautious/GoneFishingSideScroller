extends Resource
class_name Shop

@export var shop_name: String = ""
@export var categories: Array[ShopCategory] = []

func get_shop_name() -> String:
	return shop_name
