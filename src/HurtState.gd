extends "OnGroundState.gd"

export(int) var MAX_SPEED = 300

var roll_vector = Vector2()


func animate():
	get_animation_state().travel("Hurt")


func enter():
	owner.hurt_cooldown()
	var look_direction = owner.get_look_direction()

	velocity = velocity.move_toward(look_direction * MAX_SPEED, ACCELERATION)
	animate()


func _on_hurt_finished():
	emit_signal("finished", "Idle")


func update(delta):
	if roll_vector != Vector2.ZERO:
		owner.update_look_direction(roll_vector)
		velocity = velocity.move_toward(-(roll_vector * MAX_SPEED), (ACCELERATION * 2) * -delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 2) * delta)

	var collision = owner.move(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.normal)
