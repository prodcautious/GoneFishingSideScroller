extends CharacterBody2D

@export var movement_speed = 150
@export var jump_velocity = -300

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var camera_2d: Camera2D = %Camera2D
@onready var state_label: Label = %StateLabel

enum PLAYER_STATE {IDLE, WALKING, JUMPING, INTERACTING, FISHING}
var current_player_state

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction : float

@onready var fishing_rod: Node2D = %FishingRod

#region Built-In
func _ready() -> void:
	animation_player.play("idle_right") # FIXED
	current_player_state = PLAYER_STATE.IDLE

func _physics_process(delta):
	if current_player_state in [PLAYER_STATE.FISHING, PLAYER_STATE.INTERACTING]:
		_update_animation()
		return

	if not is_on_floor():
		if current_player_state not in [PLAYER_STATE.JUMPING]:
			set_state(2)
		velocity.y += gravity * delta
	else:
		if current_player_state == PLAYER_STATE.JUMPING:
			set_state(0)

	if is_on_floor() and velocity == Vector2.ZERO:
		if current_player_state not in [PLAYER_STATE.IDLE]:
			set_state(0)
	elif is_on_floor() and velocity != Vector2.ZERO:
		if current_player_state not in [PLAYER_STATE.WALKING]:
			set_state(1)

	_get_input()
	_update_animation()
	move_and_slide()
#endregion

#region Public Helpers
func get_current_state() -> String:
	match current_player_state:
		PLAYER_STATE.IDLE:
			return "Idle"
		PLAYER_STATE.WALKING:
			return "Walking"
		PLAYER_STATE.JUMPING:
			return "Jumping"
		PLAYER_STATE.INTERACTING:
			return "Interacting"
		PLAYER_STATE.FISHING:
			return "Fishing"
		_:
			return "No state found"

func set_state(state: int) -> void:
	match state:
		0:
			current_player_state = PLAYER_STATE.IDLE
			state_label.text = "Idle"
			print("Setting state to: Idle")
		1:
			current_player_state = PLAYER_STATE.WALKING
			state_label.text = "Walking"
			print("Setting state to: Walking")
		2:
			current_player_state = PLAYER_STATE.JUMPING
			state_label.text = "Jumping"
			print("Setting state to: Jumping")
		3:
			current_player_state = PLAYER_STATE.INTERACTING
			state_label.text = "Interacting"
			print("Setting state to: Interacting")
		4:
			current_player_state = PLAYER_STATE.FISHING
			state_label.text = "Fishing"
			print("Setting state to: Fishing")
		_:
			print("No state: ", state, " found")

#endregion

#region Private Helpers
func _get_input():
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * movement_speed
	if input_direction != 0.0:
		facing_direction = input_direction
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func _update_animation() -> void:
	var dir: String
	if facing_direction >= 0.0:
		dir = "right"
		fishing_rod.scale.x = 1.0
	else:
		dir = "left"
		fishing_rod.scale.x = -1.0

	var anim_name: String

	match current_player_state:
		PLAYER_STATE.IDLE:
			anim_name = "idle_" + dir
		PLAYER_STATE.WALKING:
			anim_name = "idle_" + dir
		PLAYER_STATE.JUMPING:
			anim_name = "idle_" + dir
		PLAYER_STATE.FISHING:
			anim_name = "fishing_" + dir
		PLAYER_STATE.INTERACTING:
			anim_name = "idle_" + dir

	# FIX: prevent restarting animation every frame
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
#endregion
