extends "OnGroundState.gd"

export(int) var MAX_SPEED = 100

var existing_input_direction


func enter():
	velocity = Vector2()
	animate()
	owner.get_node("Audio").get_node("AkSwimIn").post_event()


func animate():
	get_animation_state().travel(get_name())


func exit():
	owner.get_node("Audio").get_node("AkSwimOut").post_event()


func update(delta):
	var input_direction = get_input_direction()

	if input_direction != Vector2.ZERO:
		owner.update_look_direction(input_direction)

#		animate()
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	owner.move(velocity * delta)

	if velocity == Vector2.ZERO:
		emit_signal("finished", "SwimIdle")
