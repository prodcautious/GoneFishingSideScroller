extends Control

@onready var line_edit: LineEdit = %LineEdit

var letter_regex := RegEx.new()
var player

func _ready() -> void:

	MenuManager.register_menu(MenuManager.MenuState.NAMEINPUT, self)
	letter_regex.compile("^[A-Za-z]$")
	visibility_changed.connect(_on_visibility_changed)
	line_edit.text_changed.connect(_on_line_edit_text_changed)
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)

func _on_visibility_changed() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		player.lock()

func _on_line_edit_text_changed(new_text: String) -> void:
	var cleaned_text := ""

	for character in new_text:
		if letter_regex.search(character):
			cleaned_text += character

	if cleaned_text != new_text:
		line_edit.text = cleaned_text
		line_edit.caret_column = cleaned_text.length()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var entered_name = new_text.strip_edges()
	GameManager.player_name = entered_name
	MenuManager.pop_menu()
	var wilson_intro = get_tree().get_first_node_in_group("Wilson")
	if wilson_intro:
		wilson_intro.continue_after_name_input()
