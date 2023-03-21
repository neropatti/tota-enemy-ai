extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Idle")


func enter():
	animate()
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("finished", "Idle")


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 2) * delta)

	var collision = owner.move(velocity)

	if collision:
		velocity = velocity.bounce(collision.normal)
