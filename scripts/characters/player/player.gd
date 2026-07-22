extends CharacterBody2D

@export var movement_speed = 80
@export var jump_velocity = -300

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var camera_2d: Camera2D = %Camera2D
@onready var fishing_rod: Node2D = %FishingRod
@onready var rod_holder: Node2D = %RodHolder
@onready var feet_ray_cast_2d: RayCast2D = %FeetRayCast2D
@onready var states: StateMachine = %States

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_direction: float = 1.0
var last_facing_direction: float = 1.0
var move_input: float = 0.0

var is_fishing := false
var is_interacting := false

var player_state = null

func lock() -> void:
	states.set_state(states.states.locked)

func unlock() -> void:
	states.set_state(states.states.idle)

func _play_animation(base_name: String) -> void:
	if animation_player.current_animation != base_name:
		animation_player.play(base_name)

func _handle_move_input() -> void:
	move_input = 0.0

	if Input.is_action_pressed("left"):
		move_input = -1.0
	elif Input.is_action_pressed("right"):
		move_input = 1.0

	if move_input != 0.0:
		facing_direction = move_input

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func _apply_movement() -> void:
	velocity.x = move_input * movement_speed
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

func _update_facing_visual() -> void:
	sprite_2d.flip_h = facing_direction < 0.0
	if rod_holder:
		rod_holder.scale.x = sign(facing_direction) if facing_direction != 0 else rod_holder.scale.x

func _play_footstep_sound() -> void:
	feet_ray_cast_2d.force_raycast_update()
	
	if not feet_ray_cast_2d.is_colliding():
		return

	var collider := feet_ray_cast_2d.get_collider()

	if collider == null or not is_instance_valid(collider):
		return

	if not (collider is TileMapLayer):
		return

	var ground_tilemap := collider as TileMapLayer
	var collision_point := feet_ray_cast_2d.get_collision_point()
	var collision_normal := feet_ray_cast_2d.get_collision_normal()

	var sample_point := collision_point - collision_normal * 1.0

	var cell: Vector2i = ground_tilemap.local_to_map(ground_tilemap.to_local(sample_point))
	var tile_data: TileData = ground_tilemap.get_cell_tile_data(cell)

	if tile_data == null:
		return

	var tile_set := ground_tilemap.tile_set

	for i in tile_set.get_custom_data_layers_count():
		var layer_name := tile_set.get_custom_data_layer_name(i)

		if tile_data.get_custom_data(layer_name) == true:
			AudioManager.play_sfx("footstep_" + layer_name, randf_range(0.9, 1.1))
			print("playing footstep_" + layer_name)
			return
