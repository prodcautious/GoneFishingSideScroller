extends Node2D

@onready var line_start: Node2D = %LineStart
@onready var line_end: Node2D = %LineEnd

var bobber_noise := FastNoiseLite.new()
var time: float = 0.0
var origin_point: Vector2
var strength : float = 16.0
var speed : float = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		origin_point = line_end.position

func _draw():
	draw_line(line_start.position, line_end.position, Color(0.776, 0.847, 0.192, 1.0), 0.5)

func _process(delta: float) -> void:
	time += delta
	line_end.position = origin_point + Vector2(bobber_noise.get_noise_2d(time * speed, 0.0),
	bobber_noise.get_noise_2d(0.0, time * speed)) * strength
	queue_redraw()
