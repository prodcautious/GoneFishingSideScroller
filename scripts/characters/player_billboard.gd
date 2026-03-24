extends CharacterBody3D

@export var speed = 2
@export var jump_velocity = 4.5

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_input():
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * speed

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	get_input()
	move_and_slide()
