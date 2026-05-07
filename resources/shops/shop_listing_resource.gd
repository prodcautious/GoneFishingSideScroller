extends Resource
class_name ShopListing

@export var item: Item
@export var count: int = 1
@export var price: int = 0

func get_item() -> Item:
	return item

func get_count() -> int:
	return count

func get_price() -> int:
	return price

func set_item(new_item: Item) -> void:
	item = new_item

func set_count(new_count) -> void:
	count = new_count

func set_price(new_price) -> void:
	price = new_price

func get_stats() -> String:
	return item.get_type() + "\n
	Count: " + str(get_count()) + "\n
	$" + str(get_price())
