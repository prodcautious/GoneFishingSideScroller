extends Node2D

@onready var line_start: Node2D = %LineStart
@onready var line_end: Node2D = %LineEnd

var bobber_noise := FastNoiseLite.new()
var time: float = 0.0
var origin_point: Vector2
var strength : float = 16.0
var speed : float = 0.4

var casted_out: bool = false

func _ready() -> void:
	set_up_bobber()

func _draw():
	if casted_out:
		draw_line(line_start.position, line_end.position, Color.WHITE, 0.5)
		
func _process(delta: float) -> void:
	time += delta
	line_end.position = origin_point + Vector2(bobber_noise.get_noise_2d(time * speed, 0.0),
	bobber_noise.get_noise_2d(0.0, time * speed)) * strength
	if casted_out:
		queue_redraw()

func set_up_bobber() -> void:
	bobber_noise.seed = randi()
	origin_point = line_end.position
