extends Node

var current_version: float = 0.01

var balance: int = 100

signal game_start
signal balance_changed(total_count: int)

func increase_balance(amount: int) -> void:
	balance += amount
	balance_changed.emit(balance)

func decrease_balance(amount: int) -> void:
	if balance - amount < 0:
		balance = 0
	else:
		balance -= amount
	
	balance_changed.emit(balance)
