extends Control

@export var slot: PackedScene
@export var hotbar: Array[Item]
var MAX_HOTBAR_SIZE: int = 5

@onready var hotbar_container: HBoxContainer = %HotbarContainer
@onready var fishing_rod: Node2D = %FishingRod

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_hotbar()

func _input(event: InputEvent) -> void:
	# Inventory toggle
	if event.is_action_pressed("inventory"):
		toggle_inventory()
	elif event.is_action_pressed("esc"):
		close_inventory()
	
	# Hotbar selection
	if event.is_action_pressed("hotbar_1"):
		grab_slot_focus(0)
	elif event.is_action_pressed("hotbar_2"):
		grab_slot_focus(1)
	elif event.is_action_pressed("hotbar_3"):
		grab_slot_focus(2)
	elif event.is_action_pressed("hotbar_4"):
		grab_slot_focus(3)
	elif event.is_action_pressed("hotbar_5"):
		grab_slot_focus(4)

func populate_hotbar() -> void:
	if hotbar.size() > MAX_HOTBAR_SIZE:
		hotbar.resize(MAX_HOTBAR_SIZE)
		print("Hotbar size exceeds max hotbar size, resizing...")
	
	if slot:
		for i in MAX_HOTBAR_SIZE:
			var item: Item = null
			if i < hotbar.size():
				item = hotbar[i]
			instantiate_new_slot(item, i)
			print("Added hotbar slot at index ", i)

func instantiate_new_slot(item: Item, index: int) -> void:
	if item != null:
		var item_duplicate = item.duplicate()
		var hotbar_slot = slot.instantiate()
		hotbar_container.add_child(hotbar_slot)
		hotbar_slot.item = item_duplicate
		hotbar_slot.icon_texture_rect.texture = item_duplicate.icon
		hotbar_slot.slot_number_label.text = str(index + 1)
	else:
		var hotbar_slot = slot.instantiate()
		hotbar_container.add_child(hotbar_slot)
		hotbar_slot.slot_number_label.text = str(index + 1)

func grab_slot_focus(index: int) -> void:
	var i = 0
	for hotbar_slot in hotbar_container.get_children():
		if i == index:
			hotbar_slot.grab_focus()
			return
		else:
			i += 1

func open_inventory() -> void:
	show()
	get_tree().paused = true
	GameManager.inventory_open = true

func close_inventory() -> void:
	hide()
	get_tree().paused = false
	GameManager.inventory_open = false

func toggle_inventory() -> void:
	if visible:
		close_inventory()
	elif !visible && !GameManager.pause_menu_open:
		open_inventory()
