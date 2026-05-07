extends Control

@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var item_stats: Label = %ItemStats
@onready var item_button: Button = %ItemButton
@onready var desc_panel_container: PanelContainer = %DescPanelContainer

@export var listing: ShopListing

var tooltip_layer: Control

#region Built-In
func _ready() -> void:
	await get_tree().process_frame
	_connect_signals()
#endregion

#region Helpers
func _connect_signals() -> void:
	item_button.mouse_entered.connect(_on_item_button_mouse_entered)
	item_button.mouse_exited.connect(_on_item_button_mouse_exited)
	item_button.pressed.connect(_on_item_button_pressed)

func set_up_slot(new_listing: ShopListing) -> void:
	listing = new_listing

	icon_texture_rect.texture = listing.item.get_icon()
	item_stats.text = listing.get_stats()
#endregion

#region Signals
func _on_item_button_mouse_entered() -> void:
	# would love to find a better workaround for this
	desc_panel_container.reparent(tooltip_layer)
	desc_panel_container.global_position = item_button.global_position + Vector2(0, -desc_panel_container.size.y - 8)
	desc_panel_container.show()
	desc_panel_container.z_index = 999

func _on_item_button_mouse_exited() -> void:
	desc_panel_container.hide()

func _on_item_button_pressed() -> void:
	if GameManager.balance >= listing.get_price():
		
		var item = listing.get_item()
		var fishing_rod = FishingRodManager.fishing_rod

		if item is Bait:
			var bait = fishing_rod.get_current_bait()
			if bait == null:
				fishing_rod.set_bait(item.duplicate())
				fishing_rod.get_current_bait().set_count(listing.get_count())
			else:
				bait.set_count(bait.get_count() + listing.get_count())
				
			GameManager.decrease_balance(listing.get_price())
		elif item is Hook:
			var hook = fishing_rod.get_current_hook()
		
			if hook == null:
				fishing_rod.set_hook(item.duplicate())
				fishing_rod.get_current_hook().set_count(listing.get_count())
			else:
				hook.set_count(hook.get_count() + listing.get_count())

			GameManager.decrease_balance(listing.get_price())
#endregion
