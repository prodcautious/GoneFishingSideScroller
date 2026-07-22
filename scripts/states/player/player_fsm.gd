extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("walking")
	add_state("fishing")
	add_state("jumping")
	add_state("falling")
	add_state("interacting")
	add_state("locked")

	call_deferred("set_state", states.idle)

func _state_logic(delta: float) -> void:
	match state:
		states.locked:
			parent.move_input = 0.0
			parent.velocity.x = 0.0
			parent._apply_gravity(delta)
			parent.move_and_slide()
		
		states.idle:
			parent._apply_gravity(delta)
			parent._handle_move_input()
			parent._apply_movement()
			parent._update_facing_visual()

		states.walking:
			parent._apply_gravity(delta)
			parent._handle_move_input()
			parent._apply_movement()
			parent._update_facing_visual()

		states.fishing:
			parent.move_input = 0.0
			parent.velocity.x = 0
			parent._apply_gravity(delta)
			parent.move_and_slide()
			parent._update_facing_visual()

		states.interacting:
			parent.move_input = 0.0
			parent.velocity.x = 0.0
			parent._apply_gravity(delta)
			parent.move_and_slide()
			parent._update_facing_visual()

		states.jumping:
			parent._apply_gravity(delta)
			parent._handle_move_input()
			parent._apply_movement()
			parent._update_facing_visual()

		states.falling:
			parent._apply_gravity(delta)
			parent._handle_move_input()
			parent._apply_movement()
			parent._update_facing_visual()

func _get_transition(delta: float):
	match state:
		states.locked:
			return null

		states.idle:
			if parent.is_fishing:
				return states.fishing

			if parent.is_interacting:
				return states.interacting

			if not parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling

			if parent.velocity.x != 0:
				return states.walking

		states.walking:
			if parent.is_fishing:
				return states.fishing

			if parent.is_interacting:
				return states.interacting

			if not parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling

			if parent.velocity.x == 0:
				return states.idle

		states.jumping:
			if parent.is_fishing:
				return states.fishing

			if parent.is_interacting:
				return states.interacting

			if parent.is_on_floor():
				return states.idle

			if parent.velocity.y > 0:
				return states.falling

		states.falling:
			if parent.is_fishing:
				return states.fishing

			if parent.is_interacting:
				return states.interacting

			if parent.is_on_floor():
				return states.idle

			if parent.velocity.y < 0:
				return states.jumping

		states.fishing:
			if not parent.is_fishing:
				return states.idle

		states.interacting:
			if not parent.is_interacting:
				return states.idle

	return null

func _enter_state(new_state, old_state) -> void:
	parent.player_state = new_state

	match new_state:
		states.locked:
			parent.move_input = 0.0
			parent.velocity.x = 0.0
			parent._play_animation("idle")

		states.idle:
			parent._play_animation("idle")

		states.walking:
			parent._play_animation("walking")

		states.fishing:
			parent._play_animation("fishing")

		states.interacting:
			parent._play_animation("idle")

		# replace with actual jumping and falling animations at some point
		states.jumping:
			parent._play_animation("idle")

		states.falling:
			parent._play_animation("idle")

func _exit_state(old_state, new_state) -> void:
	pass
