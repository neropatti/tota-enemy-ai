extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func enter():
	animate()


func update(_delta):
	pass
