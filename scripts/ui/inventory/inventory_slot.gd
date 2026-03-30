extends PanelContainer

@onready var desc_label: Label = %DescLabel
@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var sell_button: Button = %SellButton

var can_sell: bool = false

var item: Item

func _ready() -> void:
	await get_tree().process_frame
	sell_button.pressed.connect(_on_sell_button_pressed)
	sell_button.visible = can_sell

func _on_sell_button_pressed() -> void:
	GameManager.money += item.get_price()
	desc_label.text = ""
	icon_texture_rect.texture = null
	sell_button.visible = false
	can_sell = false
	item = null
