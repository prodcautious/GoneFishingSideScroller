extends Control

var player

@onready var line_edit: LineEdit = %LineEdit
@onready var console_output_label: RichTextLabel = %ConsoleOutputLabel

func _ready() -> void:
	hide()
	_connect_signals()
	_register_menu()

func _input(event: InputEvent) -> void:
	if !OptionsManager.debug:
		return

	if event.is_action_pressed("command"):
		get_viewport().set_input_as_handled()
		_toggle_visibility()
		return

	if visible and event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		_toggle_visibility()
		return

#region Helpers
func _toggle_visibility() -> void:
	if SceneTransition.is_transitioning:
		return

	if MenuManager.current_menu == MenuManager.MenuState.START:
		return

	if visible and MenuManager.current_menu != MenuManager.MenuState.CONSOLE :
		get_tree().paused = true
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.lock()
		if line_edit.text == "":
			line_edit.text = "/"

		line_edit.caret_column = line_edit.text.length()
		line_edit.call_deferred("grab_focus")
		MenuManager.show_menu(MenuManager.MenuState.CONSOLE, true)
		return

	if visible:
		hide()
		get_tree().paused = false
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.unlock()
		MenuManager.close_current_menu()
	else:
		show()
		if line_edit.text == "":
			line_edit.text = "/"

		line_edit.caret_column = line_edit.text.length()
		line_edit.call_deferred("grab_focus")
		MenuManager.show_menu(MenuManager.MenuState.CONSOLE, true)

func _register_menu() -> void:
	MenuManager.register_menu(MenuManager.MenuState.CONSOLE, self)

func _connect_signals() -> void:
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	line_edit.text_changed.connect(_on_line_edit_text_changed)

func _append_console_output(text: String) -> void:
	console_output_label.append_text("\n- " + text)
#endregion

#region Signals
func _on_line_edit_text_submitted(new_text: String) -> void:
	var parts := new_text.strip_edges().split(" ", false)

	if parts.size() < 1:
		return

	match parts[0]:
		"/give":
			_handle_give(parts)
		"/clear":
			_handle_clear(parts)
		"/balance":
			_handle_balance(parts)
		"/help":
			_append_console_output("Available Commands:")
			_append_console_output("/give <fish> <amount>")
			_append_console_output("/clear inventory")
			_append_console_output("/balance <add/remove/clear> <amount>")
		_:
			_append_console_output("Unknown command. Type /help for commands.")

	line_edit.text = "/"
	line_edit.caret_column = line_edit.text.length()

func _on_line_edit_text_changed(new_text: String) -> void:
	var caret := line_edit.caret_column
	var cleaned := new_text

	for character in "`\\?\"'<>|":
		cleaned = cleaned.replace(character, "")

	if cleaned != new_text:
		line_edit.text = cleaned
		line_edit.caret_column = max(caret - 1, 0)

func _on_clear_output_timer_timeout() -> void:
	console_output_label.clear()
#endregion

#region Command Handlers
func _handle_balance(parts: PackedStringArray) -> void:
	if parts.size() < 2:
		_append_console_output("Usage: /balance <add/remove> <amount>")
		return

	if parts.size() < 3:
		_append_console_output("Usage: /balance <add/remove> <amount>")

	var amount := parts[2].to_int()
	
	if amount <= 0:
		_append_console_output("Amount must be greater than 0")
		return

	var command := parts[1]

	match command:
		"add":
			GameManager.increase_balance(amount)
			_append_console_output("Added $" + str(amount) + " to balance ($" + str(GameManager.balance) + " total)")
		"remove":

			
			GameManager.decrease_balance(amount)
			if GameManager.balance < amount:
				_append_console_output("Amount is greater than current balance. Setting to zero")
			else:
				_append_console_output("Removed $" + str(amount) + " from balance ($" + str(GameManager.balance) + " total)")
		_:
			_append_console_output("Usage: /balance <add/remove> <amount>")

func _handle_give(parts: PackedStringArray) -> void:
	if parts.size() < 3:
		_append_console_output("Usage: /give <fish> <amount>")
		return

	var fish_name := parts[1]
	var amount := parts[2].to_int()

	if amount <= 0:
		_append_console_output("Amount must be greater than 0")
		return

	if !FishManager.fish.has(fish_name):
		_append_console_output("Fish not found: " + fish_name)
		return

	for i in amount:
		var fish_data: Dictionary = FishManager.fish[fish_name]
		var new_fish := FishManager.make_fish_resource(
			fish_data["name"],
			fish_data,
			randf_range(0.0, 1.0), # cast_power
			0.25, # weight_bias
			0.75  # price_bias
		)

		InventoryManager.add_fish_to_inventory(new_fish)

	_append_console_output("Gave player " + str(amount) + " " + fish_name)

func _handle_clear(parts: PackedStringArray) -> void:
	if parts.size() < 2:
		_append_console_output("Usage: /clear <inventory/balance>")
		return

	match parts[1]:
		"inventory":
			InventoryManager.clear_inventory()
			_append_console_output("Cleared inventory")
		"balance":
			GameManager.balance = 0
			_append_console_output("Cleared balance")
		_:
			_append_console_output("Usage: /clear <inventory/balance>")
#endregion
