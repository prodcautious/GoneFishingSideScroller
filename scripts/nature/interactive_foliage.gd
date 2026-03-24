extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_group("Physics")
@export var stiffness: float = 5.0
@export var damping: float = 4.0
@export var impulse_strength: float = 16.0
@export var continuous_force: float = 12.0   # Push applied every frame while inside
@export var max_skew: float = 20.0           # Clamp so it doesn't go wild

var _skew: float = 0.0
var _velocity: float = 0.0
var _bodies_inside: Array = []

func _ready() -> void:
	set_physics_process(true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	# Push continuously based on whoever is inside
	for body in _bodies_inside:
		var direction := global_position.direction_to(body.global_position)
		var speed_factor := 1.0
		if body.get("velocity") != null:
			speed_factor = clamp(body.velocity.length() / 100.0, 0.3, 3.0)
		_velocity += -direction.x * continuous_force * speed_factor * delta

	var spring_force := -stiffness * _skew
	var damping_force := -damping * _velocity
	_velocity += (spring_force + damping_force) * delta
	_skew = clamp(_skew + _velocity * delta, -max_skew, max_skew)

	sprite_2d.material.set_shader_parameter("skew", _skew)

func _on_body_entered(body: Node2D) -> void:
	if body != get_tree().get_first_node_in_group("Player"):
		return
	_bodies_inside.append(body)

	# Initial punch on entry
	var direction := global_position.direction_to(body.global_position)
	var speed_factor := 1.0
	if body.get("velocity") != null:
		speed_factor = clamp(body.velocity.length() / 100.0, 0.5, 3.0)
	_velocity += -direction.x * impulse_strength * speed_factor

func _on_body_exited(body: Node2D) -> void:
	_bodies_inside.erase(body)
