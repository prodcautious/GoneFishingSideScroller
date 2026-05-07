extends Control

@onready var accessory_slots: Array[Node] = [
	%RodAccessorySlot,
	%RodAccessorySlot2,
	%RodAccessorySlot3,
	%RodAccessorySlot4
]

func _ready() -> void:
	hide()
	_register_menu()

func _unhandled_input(event: InputEvent) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player.current_player_state == player.PLAYER_STATE.FISHING:
		return
	
	if event.is_action_pressed("open_accessories"):
		get_viewport().set_input_as_handled()
		_toggle_visibility()

func _toggle_visibility() -> void:
	if MenuManager.current_menu == MenuManager.MenuState.START:
		print("currently on start")
		return

	if visible:
		hide()
		MenuManager.close_current_menu()
	else:
		load_rod_accessories()
		show()
		MenuManager.show_menu(MenuManager.MenuState.ACCESSORIES, true)

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.ACCESSORIES, self)

func load_rod_accessories() -> void:
	var rod: FishingRod = InventoryManager.fishing_rod

	for slot in accessory_slots:
		slot.reset_slot()

	var accessories: Array[FishingAccessory] = [
		rod.get_hook(),
		rod.get_bobber(),
		rod.get_bait(),
		rod.get_line()
	]

	for i in accessories.size():
		if i >= accessory_slots.size():
			break

		if accessories[i] == null:
			continue

		accessory_slots[i].accessory = accessories[i]
		accessory_slots[i].set_up_slot()
