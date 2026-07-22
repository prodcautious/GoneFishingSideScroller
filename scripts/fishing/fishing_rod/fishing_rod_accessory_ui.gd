extends Control

@export var accessory_slot: PackedScene

@onready var accessory_slots: Array[Node] = [
	%RodAccessorySlot,
	%RodAccessorySlot2,
	%RodAccessorySlot3,
]

@onready var accessory_h_box_container: HBoxContainer = %AccessoryHBoxContainer
@onready var accessory_panel_container: PanelContainer = %AccessoryPanelContainer
@onready var accessory_header_label: Label = %AccessoryHeaderLabel

var current_category: FishingAccessory.AccessoryType
var accessory_panel_open: bool = false


#region Built-In
func _ready() -> void:
	_register_menu()
	_connect_manager_signals()
	_connect_current_rod_signals()

	close_accessory_panel()
	hide()


#func _unhandled_input(event: InputEvent) -> void:
	#if _player_is_fishing():
		#return

	#if event.is_action_pressed("open_accessories"):
		#get_viewport().set_input_as_handled()

		#if not _can_open_accessories():
			#return

		#_handle_accessory_menu_input()

	#elif event.is_action_pressed("esc") and visible:
		#get_viewport().set_input_as_handled()
		#_handle_escape_input()
#endregion


#region Input / Menu Flow
func _handle_accessory_menu_input() -> void:
	if MenuManager.is_open(MenuManager.MenuState.ACCESSORIES):
		if accessory_panel_open:
			close_accessory_panel()
		else:
			close_accessories_menu()
	else:
		open_accessories_menu()


func _handle_escape_input() -> void:
	if accessory_panel_open:
		close_accessory_panel()
	else:
		close_accessories_menu()


func _can_open_accessories() -> bool:
	if MenuManager.is_menu_open() and not MenuManager.is_open(MenuManager.MenuState.ACCESSORIES):
		return false

	if MenuManager.current_menu == MenuManager.MenuState.START:
		return false

	return _get_rod() != null


#func _player_is_fishing() -> bool:
	#var player = get_tree().get_first_node_in_group("Player")

	#if player == null:
		#return false

	#return player.current_player_state == player.PLAYER_STATE.FISHING
#endregion


#region Open / Close
func open_accessories_menu() -> void:
	var rod := _get_rod()

	if rod == null:
		push_warning("Cannot open accessories menu because no fishing rod is equipped.")
		return

	close_accessory_panel()
	load_rod_accessories()

	MenuManager.show_menu(MenuManager.MenuState.ACCESSORIES, true)


func close_accessories_menu() -> void:
	close_accessory_panel()
	MenuManager.close_current_menu()


func open_accessory_panel() -> void:
	accessory_panel_container.show()
	accessory_panel_open = true


func close_accessory_panel() -> void:
	accessory_panel_container.hide()
	accessory_panel_open = false
	clear_accessory_choices()
#endregion


#region Equipped Accessory Slots
func load_rod_accessories() -> void:
	var rod := _get_rod()

	if rod == null:
		return

	_reset_equipped_slots()

	var current_accessories: Array[FishingAccessory] = [
		rod.get_current_hook(),
		rod.get_current_bait(),
		rod.get_current_line()
	]

	for i in current_accessories.size():
		if i >= accessory_slots.size():
			break

		var accessory := current_accessories[i]

		if accessory == null:
			continue

		_setup_equipped_slot(accessory_slots[i], accessory)


func _reset_equipped_slots() -> void:
	for slot in accessory_slots:
		slot.reset_slot()


func _setup_equipped_slot(slot: Node, accessory: FishingAccessory) -> void:
	slot.set_up_slot(
		accessory,
		slot.SlotMode.EQUIPPED,
		true
	)

	if not slot.equipped_slot_pressed.is_connected(_on_equipped_slot_pressed):
		slot.equipped_slot_pressed.connect(_on_equipped_slot_pressed)


func _on_equipped_slot_pressed(accessory: FishingAccessory) -> void:
	if accessory == null:
		return

	show_accessories_for_type(accessory.get_accessory_type())
#endregion


#region Accessory Selection Panel
func show_accessories_for_type(type: FishingAccessory.AccessoryType) -> void:
	var rod := _get_rod()

	if rod == null:
		return

	current_category = type

	var accessories: Array = rod.get_accessories_by_type(type)
	var current_accessory: FishingAccessory = rod.get_current_accessory_by_type(type)

	display_accessories(type, accessories, current_accessory)


func display_accessories(
	type: FishingAccessory.AccessoryType,
	accessories: Array,
	current_accessory: FishingAccessory
) -> void:
	clear_accessory_choices()

	accessory_header_label.text = get_accessory_header_text(type)

	for accessory in accessories:
		if accessory == null:
			continue

		_create_selection_slot(accessory, current_accessory)

	open_accessory_panel()


func _create_selection_slot(
	accessory: FishingAccessory,
	current_accessory: FishingAccessory
) -> void:
	var new_slot = accessory_slot.instantiate()
	accessory_h_box_container.add_child(new_slot)

	var is_current := accessory == current_accessory

	new_slot.set_up_slot(
		accessory,
		new_slot.SlotMode.SELECTION,
		is_current
	)

	new_slot.selection_slot_pressed.connect(_on_selection_slot_pressed)


func clear_accessory_choices() -> void:
	for child in accessory_h_box_container.get_children():
		child.queue_free()


func _on_selection_slot_pressed(accessory: FishingAccessory) -> void:
	if accessory == null:
		return

	var rod := _get_rod()

	if rod == null:
		return

	rod.equip_accessory(accessory)

	load_rod_accessories()
	show_accessories_for_type(accessory.get_accessory_type())
#endregion


#region Rod Signals
func _connect_manager_signals() -> void:
	if not FishingRodManager.fishing_rod_changed.is_connected(_on_fishing_rod_changed):
		FishingRodManager.fishing_rod_changed.connect(_on_fishing_rod_changed)


func _connect_current_rod_signals() -> void:
	var rod := _get_rod()

	if rod == null:
		return

	if not rod.equipment_changed.is_connected(_on_rod_equipment_changed):
		rod.equipment_changed.connect(_on_rod_equipment_changed)


func _on_fishing_rod_changed(_rod: FishingRod) -> void:
	_connect_current_rod_signals()

	if visible:
		load_rod_accessories()

		if accessory_panel_open:
			show_accessories_for_type(current_category)


func _on_rod_equipment_changed() -> void:
	if not visible:
		return

	load_rod_accessories()

	if accessory_panel_open:
		show_accessories_for_type(current_category)
#endregion


#region Helpers
func _get_rod() -> FishingRod:
	return FishingRodManager.fishing_rod


func get_accessory_header_text(type: FishingAccessory.AccessoryType) -> String:
	match type:
		FishingAccessory.AccessoryType.BAIT:
			return "Bait"
		FishingAccessory.AccessoryType.HOOK:
			return "Hooks"
		FishingAccessory.AccessoryType.LINE:
			return "Line"
		_:
			return "Accessories"


func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.ACCESSORIES, self)
#endregion
