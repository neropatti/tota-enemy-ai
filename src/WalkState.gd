extends "OnGroundState.gd"

export(int) var MAX_SPEED = 100

var existing_input_direction


func enter():
	velocity = Vector2()
	animate()


func animate():
	get_animation_state().travel(get_name())


func play_footstep():
	owner.sound_fx.play_footstep()


func update(delta):
	var input_direction = get_input_direction()

	if input_direction != Vector2.ZERO:
		owner.update_look_direction(input_direction)
		animate()
		velocity = velocity.move_toward(input_direction * MAX_SPEED, (ACCELERATION / 2) * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 2) * delta)

	if velocity == Vector2.ZERO:
		emit_signal("finished", "Idle")

	owner.move(velocity * delta)
