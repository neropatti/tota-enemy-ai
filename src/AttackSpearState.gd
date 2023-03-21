extends "OnGroundState.gd"

export(int) var MAX_SPEED = 300

var look_direction: Vector2


func enter():
	look_direction = owner.get_look_direction()

	velocity = velocity.move_toward(look_direction * MAX_SPEED, ACCELERATION * 1.5)
	animate()
	owner.sound_fx.spear_attack()


func animate():
	get_animation_state().travel(get_name())


func handle_input(event: InputEvent):
	return


func on_finish_attack():
	emit_signal("finished", "Idle")


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 2) * delta)
	var collision = owner.move(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.normal)
