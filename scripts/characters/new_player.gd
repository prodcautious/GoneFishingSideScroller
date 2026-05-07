extends CharacterBody2D

@export var movement_speed: float = 150.0
@export var jump_velocity: float = -300.0

@onready var state_animation_player: AnimationPlayer = %StateAnimationPlayer

@onready var fishing_minigame: Node2D = %FishingMinigame
@onready var rod_holder: Node2D = %RodHolder

enum PLAYER_STATE {
	IDLE,
	WALKING,
	JUMPING,
	INTERACTING,
	FISHING
}

var current_player_state: PLAYER_STATE = PLAYER_STATE.IDLE
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction: float = 1.0


func _ready() -> void:
	_update_animation()

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)

	if current_player_state in [PLAYER_STATE.FISHING, PLAYER_STATE.INTERACTING]:
		_update_animation()
		move_and_slide()
		return

	_get_input()
	_update_movement_state()
	_update_animation()

	move_and_slide()

func set_state(state: PLAYER_STATE) -> void:
	if current_player_state == state:
		return

	current_player_state = state
	_update_animation()

func get_current_state() -> String:
	return PLAYER_STATE.keys()[current_player_state].capitalize()

func face_direction(dir: float) -> void:
	if dir == 0.0:
		return

	facing_direction = dir
	_update_animation()

func _get_input() -> void:
	var input_direction := Input.get_axis("left", "right")
	velocity.x = input_direction * movement_speed

	if input_direction != 0.0:
		facing_direction = input_direction

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		set_state(PLAYER_STATE.JUMPING)

func _update_movement_state() -> void:
	if not is_on_floor():
		set_state(PLAYER_STATE.JUMPING)
	elif velocity.x == 0.0:
		set_state(PLAYER_STATE.IDLE)
	else:
		set_state(PLAYER_STATE.WALKING)

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

func _update_animation() -> void:
	var dir := "right" if facing_direction >= 0.0 else "left"
	rod_holder.scale.x = 1.0 if dir == "right" else -1.0

	var anim_name := _get_animation_name(dir)

	if state_animation_player.current_animation != anim_name:
		state_animation_player.play(anim_name)

func _get_animation_name(dir: String) -> String:
	match current_player_state:
		PLAYER_STATE.FISHING:
			return "fishing_" + dir

		PLAYER_STATE.INTERACTING:
			return "idle_" + dir

		_:
			if fishing_minigame.rod_equipped:
				return "fishing_" + dir
			else:
				return "idle_" + dir
