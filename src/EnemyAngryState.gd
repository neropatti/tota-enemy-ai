extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Idle")


func enter():
	animate()
	var delay_period = rand_range(0.5, 1.5)
	yield(get_tree().create_timer(delay_period), "timeout")
	emit_signal("finished", "Idle")


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 2) * delta)

	var collision = owner.move(velocity)

	if collision:
		velocity = velocity.bounce(collision.normal)
