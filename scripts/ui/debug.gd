extends CanvasLayer

@onready var fps_label: Label = %FPSLabel
@onready var state_label: Label = %StateLabel

var old_fps
var new_fps

var old_state
var new_state

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	hide()

func _process(delta: float) -> void:
	update_fps_label()
	update_state_label()

func update_fps_label() -> void:
	old_fps = new_fps
	new_fps = Engine.get_frames_per_second()
	
	if old_fps != new_fps:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func update_state_label() -> void:
	old_state = new_state
	new_state = player.get_current_state()
	
	if old_state != new_state:
		state_label.text = "State: " + player.get_current_state()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		if visible:
			hide()
		else:
			show()
