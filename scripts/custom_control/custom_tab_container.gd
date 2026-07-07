extends TabContainer
class_name CustomTabContainer

func _ready() -> void:
	tab_changed.connect(_on_tab_changed)
	tab_hovered.connect(_on_tab_hovered)

func _on_tab_changed(_tab: int) -> void:
	AudioManager.play_sfx("ui_pressed")

func _on_tab_hovered(tab: int) -> void:
	if tab != current_tab:
		AudioManager.play_sfx("ui_hover")
