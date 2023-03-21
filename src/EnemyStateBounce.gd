extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Idle")


func enter():
	animate()


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta)

	owner.move(velocity)

	if velocity == Vector2.ZERO:
		emit_signal("finished", "Idle")
