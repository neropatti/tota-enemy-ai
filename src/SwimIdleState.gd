extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func enter():
	velocity = Vector2.ZERO
	animate()


func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "Swim")
