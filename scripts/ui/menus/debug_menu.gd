extends CanvasLayer

@onready var fps_label: Label = %FPSLabel
@onready var state_label: Label = %StateLabel
@onready var balance_label: Label = %BalanceLabel
@onready var position_label: Label = %PositionLabel

var old_fps
var new_fps

var old_state
var new_state

var old_balance
var new_balance

var old_position
var new_position

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	SceneTransition.transition_complete.connect(_on_transition_complete)
	hide()

func _process(_delta: float) -> void:
	if !player:
		return
	update_fps_label()
	update_state_label()
	update_balance_label()
	update_position_label()
	
func update_fps_label() -> void:
	old_fps = new_fps
	new_fps = Engine.get_frames_per_second()
	
	if old_fps != new_fps:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func update_state_label() -> void:
	if player:
		old_state = new_state
		new_state = player.get_current_state()
		
		if old_state != new_state:
			state_label.text = "State: " + player.get_current_state()
	
	else:
		if state_label.text != "No player":
			state_label.text = "No player"

func update_balance_label() -> void:
	old_balance = new_balance
	new_balance = GameManager.balance
	
	if old_balance != new_balance:
		balance_label.text = "Balance: " + str(new_balance)

func update_position_label() -> void:
	old_position = new_position
	new_position = player.position
	
	if old_position != new_position:
		var tile_x = int(new_position.x / 16)
		var tile_y = int(new_position.y / 16)

		position_label.text = "Position: " + str(tile_x) + "," + str(tile_y)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		if visible:
			hide()
		else:
			show()

func _on_transition_complete() -> void:
	player = get_tree().get_first_node_in_group("Player")
