extends Control

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("controls"):
		toggle_controls()
	elif event.is_action_pressed("esc"):
		if visible:
			close_controls()

func open_controls() -> void:
	show()
	get_tree().paused = true
	GameManager.controls_open = true

func close_controls() -> void:
	hide()
	get_tree().paused = false
	GameManager.controls_open = false

func toggle_controls() -> void:
	if GameManager.in_shop_ui || GameManager.paused || GameManager.inventory_open:
		return
	
	if visible:
		close_controls()
	else:
		open_controls()
