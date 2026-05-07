extends Label
class_name BalanceLabel

var old_balance : int
var displayed_balance : int

var tween : Tween

func _ready() -> void:
	old_balance = GameManager.balance
	displayed_balance = old_balance
	text = "$" + str(old_balance)
	_connect_signals()

func _connect_signals() -> void:
	GameManager.balance_changed.connect(_on_balance_changed)

func _on_balance_changed(balance: int) -> void:
	AudioManager.play_sfx("sell_item")
	if tween:
		tween.kill()
	var old_balance_string: String = "$" + str(old_balance)
	var new_balance_string: String = "$" + str(balance)
	text = old_balance_string
	tween = create_tween()

	tween.tween_property(self, "text", new_balance_string, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	old_balance = balance
