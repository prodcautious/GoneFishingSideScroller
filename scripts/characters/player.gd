extends CharacterBody2D

@export var movement_speed = 80
@export var jump_velocity = -300

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var camera_2d: Camera2D = %Camera2D
@onready var fishing_node: Node2D = %FishingNode
@onready var rod_holder: Node2D = %RodHolder

enum PLAYER_STATE {IDLE, WALKING, INTERACTING, FISHING}
var current_player_state

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction : float = 1.0

#region Built-In
func _ready() -> void:
	animation_player.play("idle_right")
	current_player_state = PLAYER_STATE.IDLE

func _physics_process(delta):
	if current_player_state in [PLAYER_STATE.FISHING, PLAYER_STATE.INTERACTING]:
		_apply_gravity(delta)
		_update_animation()
		move_and_slide()
		return

	# Apply gravity
	_apply_gravity(delta)

	if velocity.x == 0:
		if current_player_state != PLAYER_STATE.IDLE:
			set_state(0)
	else:
		if current_player_state != PLAYER_STATE.WALKING:
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
		1:
			current_player_state = PLAYER_STATE.WALKING
		2:
			current_player_state = PLAYER_STATE.INTERACTING
		3:
			current_player_state = PLAYER_STATE.FISHING
		_:
			print("No state: ", state, " found")

	_update_animation()
#endregion

#region Private Helpers
func _get_input():
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * movement_speed
	
	if input_direction != 0.0:
		facing_direction = input_direction

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func face_direction(dir: float) -> void:
	if dir == 0.0:
		return
	
	facing_direction = dir
	_update_animation()

func _update_animation() -> void:
	var dir: String
	if facing_direction >= 0.0:
		dir = "right"
		rod_holder.scale.x = 1.0
	else:
		dir = "left"
		rod_holder.scale.x = -1.0

	var anim_name: String

	match current_player_state:
		PLAYER_STATE.IDLE:
			if !fishing_node.rod_equipped:
				anim_name = "idle_" + dir
			else:
				anim_name = "fishing_" + dir

		PLAYER_STATE.WALKING:
			if !fishing_node.rod_equipped:
				anim_name = "walk_" + dir
			else:
				anim_name = "fishing_" + dir

		PLAYER_STATE.FISHING:
			anim_name = "fishing_" + dir

		PLAYER_STATE.INTERACTING:
			anim_name = "idle_" + dir

	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
#endregion
