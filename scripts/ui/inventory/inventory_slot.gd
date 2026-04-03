extends PanelContainer

@onready var desc_label: Label = %DescLabel
@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var sell_button: Button = %SellButton

var can_sell: bool = false

var item: Item

func _ready() -> void:
	await get_tree().process_frame
	if item:
		sell_button.pressed.connect(_on_sell_button_pressed)
	else:
		sell_button.disabled = true

func _on_sell_button_pressed() -> void:
	GameManager.coins += item.get_price()
	InventoryManager.inventory.erase(item)
	print(InventoryManager.inventory)
	desc_label.text = ""
	icon_texture_rect.texture = null
	sell_button.disabled = true
	sell_button.text = "SELL"
	can_sell = false
	item = null
	InventoryManager.item_sold.emit()
