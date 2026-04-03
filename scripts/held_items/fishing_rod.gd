extends Node2D

# Player and UI References
@export var player: CharacterBody2D
@export var fishing_rod_ui: Control

# Resources
@export var rod_resource: FishingRod

# Onready's
@onready var fishing_line: Node2D = %FishingLine
@onready var rod_sprite_2d: Sprite2D = %RodSprite2D
@onready var bobber_sprite_2d: Sprite2D = %BobberSprite2D
@onready var try_catch_fish_timer: Timer = %TryCatchFishTimer

var rod_equipped: bool = false
var casted_out: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	try_catch_fish_timer.timeout.connect(_on_try_catch_fish_timer_timeout)

func _input(event: InputEvent) -> void:
	# Equip rod
	if event.is_action_pressed("equip_rod"):
		toggle_rod_equip()

	# Cast In/Out
	if event.is_action_pressed("cast_rod"):
		toggle_cast()

#region Casting
func toggle_rod_equip() -> void:
	if !rod_resource || player.current_player_state in [player.PLAYER_STATE.FISHING]:
		return

	if rod_equipped:
		rod_equipped = false
		rod_sprite_2d.hide()
		rod_sprite_2d.texture = null
	else:
		rod_equipped = true
		rod_sprite_2d.texture = rod_resource.held_texture
		rod_sprite_2d.show()
	fishing_rod_ui.update_rod_ui()

func toggle_cast() -> void:
	if InventoryManager.inventory.size() >= InventoryManager.MAX_INVENTORY_SIZE:
		print("Inventory full. Try selling some items first")
		return
	
	if casted_out:
		if player.current_player_state in [player.PLAYER_STATE.FISHING]:
			cast_in()
	elif !casted_out:
		if player.current_player_state not in [player.PLAYER_STATE.WALKING,
		player.PLAYER_STATE.INTERACTING,
		player.PLAYER_STATE.FISHING]:
			cast_out()
	else:
		print("Cant cast in/out.")

func cast_out() -> void:
	if rod_equipped:
		if rod_resource.get_bait().get_count() > 0 && rod_resource.get_hook().get_count() > 0:
			try_catch_fish_timer.wait_time = rod_resource.get_bobber().get_bite_detection_speed()
			casted_out = true
			player.set_state(4)
			fishing_line.casted_out = true
			fishing_line.queue_redraw()
			try_catch_fish_timer.start()
		else:
			print("No bait or hooks. Try getting some at the market.")
	else:
		print("No rod equipped.")

func cast_in() -> void:
	if rod_resource:
		rod_resource.get_bait().set_count(rod_resource.get_bait().get_count() - 1)
		rod_resource.get_hook().set_count(rod_resource.get_hook().get_count() - 1)
		try_catch_fish_timer.stop()
		casted_out = false
		player.set_state(0)
		fishing_line.casted_out = false
		fishing_line.queue_redraw()
	else:
		print("No rod equipped.")
#endregion

func _on_try_catch_fish_timer_timeout() -> void:
	try_catch_fish()

func try_catch_fish() -> void:
	var bait = rod_resource.get_bait()
	var bobber = rod_resource.get_bobber()
	var hook = rod_resource.get_hook()
	var line = rod_resource.get_line()
	
	# Check if bait slipped offF
	if bait.get_weight() > bobber.get_max_bait_weight():
		print("Your bait slipped off! Try getting a larger hook.")
		cast_in()
		return
	
	# Determine fish
	var fish_on_hook = FishManager.get_fish_on_hook(bait.type)
	print("Fish on hook: ", fish_on_hook.type)
	
	if fish_on_hook == null:
		print("Nothing's biting with this setup.")
		cast_in()
		return
	
	# Check if fish is too heavy
	if fish_on_hook["weight"] > line.get_max_weight():
		print("Line snapped! Fish was too heavy.")
		cast_in()
		return
	
	# Try to catch
	var catch_chance = hook.get_catch_rate()
	var rand_f = randf()
	
	# Successful catch
	if rand_f < catch_chance:
		print("You caught: ", fish_on_hook.type)
		print("Random float chance: ", rand_f)
		print("Your catch chance: ", catch_chance)
		InventoryManager.add_inventory_item(fish_on_hook)
		cast_in()
		return

	# Unsuccessful
	else:
		print("Darn! It got away.")
		print("Random float chance: ", rand_f)
		print("Your catch chance: ", catch_chance)
		cast_in()
		return

func catch_fish() -> void:
	pass
