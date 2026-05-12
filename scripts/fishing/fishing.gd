extends Node2D

# Player and UI References
@export var player: CharacterBody2D

# Onready's
@onready var fishing_line: Node2D = %FishingLine
@onready var rod_sprite_2d: Sprite2D = %RodSprite2D
@onready var bobber_sprite_2d: Sprite2D = %BobberSprite2D
@onready var try_catch_fish_timer: Timer = %TryCatchFishTimer
@onready var cast_progress_bar: ProgressBar = %CastProgressBar
@onready var ui_animation_player: AnimationPlayer = %UIAnimationPlayer
@onready var caught_fish_sprite: Sprite2D = %CaughtFishSprite
@onready var caught_fish_label: Label = %CaughtFishLabel
@onready var didnt_catch_fish_label: Label = %DidntCatchFishLabel

var rod_equipped: bool = false

var casted_out: bool = false

# Casting-minigame variables
var is_casting: bool = false
var is_decaying: bool = false
var cast_progress: float = 0.0 
var cast_time_held: float = 0.0
var cast_power: float = 0.0

const MAX_CHARGE_TIME: float = 1.5
const MIN_CAST_HOLD_TIME: float = 0.4
const PERFECT_CAST_THRESHOLD: float = 0.99
const EXPO_FACTOR: float = 3.0
const DECAY_RATE: float = 0.20 
const BITE_SPEED_BONUS: float = 0.25
const WEIGHT_BIAS: float = 0.25
const PRICE_BIAS: float = 0.25

var next_sfx_progress := 0.1
const SFX_STEP := 0.05
const MIN_PITCH := 0.8
const MAX_PITCH := 1.8

#region Built-In
func _ready() -> void:
	try_catch_fish_timer.timeout.connect(_on_try_catch_fish_timer_timeout)
	cast_progress_bar.hide()
	cast_progress_bar.min_value = 0.0
	cast_progress_bar.max_value = 100.0
	cast_progress_bar.value = 0.0

func _input(event: InputEvent) -> void:
	var current_area = get_tree().get_first_node_in_group("Area")
	
	if current_area == null or !current_area.can_fish:
		return

	if event.is_action_pressed("cast_rod"):
		if player.current_player_state == player.PLAYER_STATE.WALKING:
			return

		if InventoryManager.inventory.size() >= InventoryManager.MAX_INVENTORY_SIZE:
			print("Inventory full. Try selling some items first")
			return

		if FishingRodManager.fishing_rod == null:
			_did_not_catch_fish_animation("You need a fishing rod.")
			return

		_show_rod()

		if casted_out:
			_end_fishing()
			print("casting in")
		elif not is_casting:
			_begin_cast()

	elif event.is_action_released("cast_rod"):
		if is_casting:
			_release_cast()
			print("releasing cast")

func _process(delta: float) -> void:
	if not is_casting:
		return

	if is_decaying:
		cast_progress = max(cast_progress - DECAY_RATE * delta, 0.0)
	else:
		cast_time_held += delta
		var t := cast_time_held / MAX_CHARGE_TIME
		cast_progress = (exp(EXPO_FACTOR * t) - 1.0) / (exp(EXPO_FACTOR) - 1.0)
		cast_progress = clampf(cast_progress, 0.0, 1.0)

		if cast_progress >= next_sfx_progress:
			var pitch := lerpf(MIN_PITCH, MAX_PITCH, cast_progress)
			AudioManager.play_sfx("cast_progress", pitch)
			next_sfx_progress += SFX_STEP

		if cast_progress >= 1.0:
			is_decaying = true

	cast_progress_bar.value = cast_progress * 100.0
#endregion

#region Rod Visuals
func _show_rod() -> void:
	if FishingRodManager.fishing_rod == null:
		return

	rod_equipped = true
	rod_sprite_2d.texture = FishingRodManager.fishing_rod.held_texture
	rod_sprite_2d.show()


func _hide_rod() -> void:
	rod_equipped = false
	rod_sprite_2d.hide()
	rod_sprite_2d.texture = null
#endregion

#region Casting Minigame
func _begin_cast() -> void:
	if not _has_bait_and_hook():
		_did_not_catch_fish_animation("No bait or hooks. Try getting some at the market.")
		return

	cast_progress_bar.show()
	is_casting = true
	is_decaying = false
	cast_progress = 0.0
	cast_time_held = 0.0
	cast_progress_bar.value = 0.0
	next_sfx_progress = 0.1
	player.set_state(3)
	
func _release_cast() -> void:
	# Ignore spam clicks
	if cast_time_held < MIN_CAST_HOLD_TIME:
		is_casting  = false
		is_decaying = false
		cast_progress_bar.hide()
		cast_progress_bar.value = 0.0
		player.set_state(0)
		_hide_rod()
		return
	is_casting  = false
	is_decaying = false

	var power := cast_progress

	perform_cast(power)
	
func perform_cast(power: float) -> void:
	if power >= PERFECT_CAST_THRESHOLD:
		AudioManager.play_sfx("perfect_cast")
		ui_animation_player.play("perfect_cast")
		await ui_animation_player.animation_finished
	else:
		get_tree().paused = true
		await get_tree().create_timer(0.5, true).timeout
		get_tree().paused = false

	cast_progress_bar.hide()
	cast_progress_bar.value = 0.0
	
	cast_power = power
	cast_out()
#endregion

#region Actual Casting
func _end_fishing(lose_bait: bool = false) -> void:
	var fishing_rod = FishingRodManager.fishing_rod

	try_catch_fish_timer.stop()
	casted_out = false
	is_casting = false
	is_decaying = false

	cast_progress_bar.hide()
	cast_progress_bar.value = 0.0

	player.set_state(0)
	_hide_rod()
	fishing_line.queue_redraw()

	if lose_bait and fishing_rod != null:
		fishing_rod.consume_bait_and_hook()
	
func cast_out() -> void:
	var fishing_rod = FishingRodManager.fishing_rod

	if fishing_rod == null:
		print("No fishing rod.")
		return

	var bait = fishing_rod.get_current_bait()

	if bait == null:
		_did_not_catch_fish_animation("No bait equipped.")
		return

	var base_wait = bait.get_bite_detection_speed()
	try_catch_fish_timer.wait_time = base_wait * lerp(1.0, 1.0 - BITE_SPEED_BONUS, cast_power)
	casted_out = true
	print(casted_out)
	fishing_line.queue_redraw()
	try_catch_fish_timer.start()
#endregion

#region Fish catching logic
func _on_try_catch_fish_timer_timeout() -> void:
	try_catch_fish()

func try_catch_fish() -> void:
	var fishing_rod = FishingRodManager.fishing_rod
	
	var bait = fishing_rod.get_current_bait()
	var hook = fishing_rod.get_current_hook()
	var line = fishing_rod.get_current_line()
	
	# Determine fish
	var fish_on_hook = get_fish_on_hook(bait.get_type(), fishing_rod.get_catch_modifier())
	
	if fish_on_hook == null:
		_did_not_catch_fish_animation("Nothing's biting with this setup.")
		_end_fishing()
		return

	print("Fish on hook: ", fish_on_hook.type)
	
	# Check if fish is too heavy
	if fish_on_hook["weight"] > line.get_max_weight():
		_did_not_catch_fish_animation("Line snapped! Fish was too heavy.")
		_end_fishing()
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
		await _catch_fish_animation(fish_on_hook)
		_end_fishing(true)
		return

	# Unsuccessful
	else:
		_did_not_catch_fish_animation("Darn! It got away.")
		print("Random float chance: ", rand_f)
		print("Your catch chance: ", catch_chance)
		_end_fishing(true)
		return

func get_fish_on_hook(bait_type: String, catch_modifier: String) -> Fish:
	var eligible_fish = []
	
	var scene = get_tree().get_first_node_in_group("Area")
	var scene_water_type = scene.water_type
	
	for fish_name in FishManager.fish:
		var fish_entry = FishManager.fish[fish_name]
		if fish_entry["water_type"].has(scene_water_type):
			if fish_entry["bait"].has(bait_type):
				var no_modifier_required = fish_entry["catch_modifier"].is_empty()
				var modifier_matches = fish_entry["catch_modifier"].has(catch_modifier)
				if no_modifier_required or modifier_matches:
					eligible_fish.append({"name": fish_name, "data": fish_entry})
			

	if eligible_fish.is_empty():
		return null

	var total_catch_chance = 0.0
	for entry in eligible_fish:
		total_catch_chance += entry["data"]["catch_chance"]

	var roll = randf() * total_catch_chance
	var cumulative_chance = 0.0
	for entry in eligible_fish:
		cumulative_chance += entry["data"]["catch_chance"]
		if roll < cumulative_chance:
			return make_fish_resource(entry["name"], entry["data"])

	var fallback = eligible_fish.back()
	return make_fish_resource(fallback["name"], fallback["data"])

func make_fish_resource(fish_name: String, fish_data: Dictionary) -> Fish:
	var new_fish = Fish.new()
	new_fish.type = fish_name
	for water_type in fish_data["water_type"]:
		new_fish.water_type.append(water_type)
	for bait in fish_data["bait"]:
		if !new_fish.accepted_bait.has(bait):
			new_fish.accepted_bait.append(bait)
	new_fish.encounter_rate = fish_data["catch_chance"]

	var base_weight := randf_range(fish_data["weight"].x, fish_data["weight"].y)
	new_fish.weight = lerp(base_weight, fish_data["weight"].y, cast_power * WEIGHT_BIAS)

	new_fish.price = int(fish_data["base_price"] * lerp(1.0, 1.0 + PRICE_BIAS, cast_power))
	new_fish.icon = fish_data["texture"]
	return new_fish

func _catch_fish_animation(fish: Fish) -> void:
	casted_out = false
	_hide_rod()

	caught_fish_sprite.texture = fish.icon
	caught_fish_label.text = "+ " + fish.get_type() + " (" + str(fish.get_weight()) + "kg.)"

	get_tree().paused = true
	AudioManager.play_sfx("fish_caught")
	ui_animation_player.play("fish_caught")
	await ui_animation_player.animation_finished
	get_tree().paused = false

	_end_fishing()

func _did_not_catch_fish_animation(reason: String) -> void:
	casted_out = false
	player.set_state(0)
	_hide_rod()

	didnt_catch_fish_label.text = reason
	AudioManager.play_sfx("fish_got_away")
	ui_animation_player.play("fish_not_caught")
	await ui_animation_player.animation_finished

func _has_bait_and_hook() -> bool:
	var rod = FishingRodManager.fishing_rod
	
	if rod == null:
		return false
	
	var bait = rod.get_current_bait()
	var hook = rod.get_current_hook()
	
	if bait == null or hook == null:
		return false
	
	return bait.get_count() > 0 and hook.get_count() > 0
#endregion
