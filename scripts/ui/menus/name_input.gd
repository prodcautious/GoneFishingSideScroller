extends Control

@export var name_input_button: PackedScene
@onready var grid_container: GridContainer = %GridContainer
@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var delete_button: CustomButton = %DeleteButton
@onready var enter_button: CustomButton = %EnterButton
@onready var player_name_label: Label = %PlayerNameLabel

var player_name : String = ""

var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letter_regex := RegEx.new()
var player

func _ready() -> void:
	MenuManager.register_menu(MenuManager.MenuState.NAMEINPUT, self)
	delete_button.pressed.connect(_on_delete_button_pressed)
	enter_button.pressed.connect(_on_enter_button_pressed)
	generate_alphabet_buttons()

func generate_alphabet_buttons() -> void:
	for i in alphabet.size():
		var button := name_input_button.instantiate()
		button.get_child(0).text = alphabet[i]
		grid_container.add_child(button)
		button.pressed.connect(_on_alpha_button_pressed.bind(alphabet[i]))

func _on_delete_button_pressed() -> void:
	if player_name == "":
		pass
	else:
		player_name = player_name.left(player_name.length() - 1)
		player_name_label.text = player_name

func _on_enter_button_pressed() -> void:
	if player_name == "":
		pass
	else:
		player_name = player_name[0].to_upper() + player_name.to_lower().substr(1)
		GameManager.player_name = player_name
		SignalManager.name_input.emit()
		MenuManager.pop_menu()

func _on_alpha_button_pressed(letter: String) -> void:
	if player_name.length() >= 7:
		pass
	else:
		player_name += letter
		player_name_label.text = player_name
