extends CharacterBody2D

@export var dialogue_resource: DialogueResource
@export var npc_name: String

@export var shop: Shop
@export var shop_scene: PackedScene

@onready var detect_area_2d: Area2D = %DetectArea2D
@onready var name_label: Label = %NameLabel
@onready var interact_container: VBoxContainer = %InteractContainer

var player
var player_is_in_area: bool = false

#region Built-In
func _ready() -> void:
	_connect_signals()
	_set_up_npc()

func _input(event: InputEvent) -> void:
	if !player:
		player = get_tree().get_first_node_in_group("Player")

	if event.is_action_pressed("interact") and player_is_in_area:
		get_viewport().set_input_as_handled()

		if MenuManager.is_menu_open():
			return

		if player.current_player_state == player.PLAYER_STATE.FISHING:
			return

		get_tree().paused = true
		DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
#endregion

#region Helpers
func _connect_signals() -> void:
	detect_area_2d.area_entered.connect(_on_detect_area_entered)
	detect_area_2d.area_exited.connect(_on_detect_area_exited)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _set_up_npc() -> void:
	name_label.text = "[E] " + npc_name
	player = get_tree().get_first_node_in_group("Player")

func _toggle_detect_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if player_is_in_area:
		if parent.is_in_group("Player"):
			player_is_in_area = false
			interact_container.hide()
	else:
		if parent.is_in_group("Player"):
			player_is_in_area = true
			interact_container.show()
#endregion

#region Signals
func _on_detect_area_entered(area: Area2D) -> void:
	_toggle_detect_area_entered(area)

func _on_detect_area_exited(area: Area2D) -> void:
	_toggle_detect_area_entered(area)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue_resource:
		return

	if MenuManager.is_open(MenuManager.MenuState.SHOP):
		return

	var new_shop_scene = shop_scene.instantiate()
	Ui.add_child(new_shop_scene)
	new_shop_scene.shop = shop

	MenuManager.show_menu(MenuManager.MenuState.SHOP, true)
#endregion
