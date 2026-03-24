extends CheckBox
class_name CustomCheckBox

var tween : Tween

func _ready() -> void:
	connect_signals()
	tween_in()

func connect_signals() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func tween_in() -> void:
	if tween:
		tween.kill()

	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)

func _on_mouse_entered() -> void:
	if tween:
		tween.kill()

	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	
func _on_mouse_exited() -> void:
	if tween:
		tween.kill()

	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
	
func _on_button_down() -> void:
	if tween:
		tween.kill()

	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9,0.9), 0.1)
	
func _on_button_up() -> void:
	if tween:
		tween.kill()

	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
