extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func on_seated():
	emit_signal("finished", "SeatedFrozen")


func enter():
	animate()
	owner.update_look_direction(Vector2.DOWN)


func exit():
	pass
