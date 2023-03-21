extends "OnGroundState.gd"


func animate():
	var name = get_name()
	get_animation_state().travel(name)


func enter():
	animate()
