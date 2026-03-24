extends HBoxContainer

@onready var label: Label = %Label

func change_label_text(text: String = "") -> void:
	label.text = text
