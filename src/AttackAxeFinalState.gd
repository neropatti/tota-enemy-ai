extends "AttackAxeState.gd"


func enter():
	velocity = Vector2()
	animate()


func exit():
	pass


func animate():
	get_animation_state().travel(get_name())
	owner.sound_fx.attack_three()


func on_attack_finished():
	emit_signal("finished", "Idle")


func handle_input(event):
	return


func update(delta):
	if input_direction != Vector2.ZERO:
		owner.update_look_direction(input_direction)
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	owner.move(velocity * delta)
