extends Node2D

var player

@export var rod_resource: FishingRod

@onready var fishing_line: Node2D = %FishingLine
@onready var rod_sprite_2d: Sprite2D = %RodSprite2D
@onready var bobber_sprite_2d: Sprite2D = %BobberSprite2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cast_rod"):
		# Start Fishing
		if player.current_player_state not in [player.PLAYER_STATE.WALKING, 
		player.PLAYER_STATE.JUMPING, 
		player.PLAYER_STATE.INTERACTING,
		player.PLAYER_STATE.FISHING]:
			cast_out()
		# Cast rod in
		elif player.current_player_state in [player.PLAYER_STATE.FISHING]:
			cast_in()
		else:
			print("Cant cast in/out.")

func cast_out() -> void:
	if rod_resource:
		player.set_state(4)
		rod_sprite_2d.texture = rod_resource.icon
		rod_sprite_2d.show()
		bobber_sprite_2d.texture = rod_resource.bobber_sprite
		bobber_sprite_2d.show()
		fishing_line.casted_out = true
		fishing_line.queue_redraw()
	else:
		print("No rod equipped.")

func cast_in() -> void:
	if rod_resource:
		player.set_state(0)
		rod_sprite_2d.hide()
		bobber_sprite_2d.hide()
		fishing_line.casted_out = false
		fishing_line.queue_redraw()
	else:
		print("No rod equipped.")
