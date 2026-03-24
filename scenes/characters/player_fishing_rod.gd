extends Node2D

@export var player: CharacterBody2D
@export_group("Rod Properties")
@export var bite_time_min: float = 1.0
@export var bite_time_max: float = 3.0
@export var catch_chance: float = 0.9

@onready var fishing_rod_tooltip: HBoxContainer = %FishingRodTooltip

signal rod_casted(casted_out: bool)

var fish_on: bool = false

#region Built-In
func _ready() -> void:
	_connect_signals()

func _process(_delta: float) -> void:
	if _can_player_fish():
		fishing_rod_tooltip.show()
		return
	else:
		fishing_rod_tooltip.hide()
		return

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("cast_rod"):
		
		# If fish is hooked, try to catch a fish
		if fish_on:
			print("You reeled in a fish!")
			rod_casted.emit(false)
		
		# Rod cast functionality
		elif _can_player_fish():
			_cast_rod()
		else:
			print("Can't cast rod")
#endregion

#region Private Helpers
func _connect_signals() -> void:
	rod_casted.connect(_on_rod_casted)

func _cast_rod() -> void:
	var player_state = player.get_player_state()

	# Casting in
	if player_state == "Fishing":
		rod_casted.emit(false)

	# Able to cast
	elif player_state == "Idle":
		rod_casted.emit(true)

func _try_hook_fish() -> void:
	if catch_chance > randf():
		print("fish on!")
		fish_on = true
	else:
		print("unluckeh!")
		rod_casted.emit(false)

func _on_rod_casted(casted_out: bool) -> void:
	if casted_out:
		player.current_player_state = player.PLAYER_STATE.FISHING
		fishing_rod_tooltip.change_label_text("cast rod in")
		print("do fishing stuff")
		await get_tree().create_timer(randf_range(bite_time_min, bite_time_max)).timeout
		_try_hook_fish()
	else:
		player.current_player_state = player.PLAYER_STATE.IDLE
		fishing_rod_tooltip.change_label_text("cast rod out")
		print("cancel fishing stuff")
		fish_on = false

func _can_player_fish() -> bool:
	# Player can either be idle or fishing to cast in or out
	if player.current_player_state == player.PLAYER_STATE.IDLE || player.current_player_state == player.PLAYER_STATE.FISHING:
		return true
	else:
		return false
#endregion
