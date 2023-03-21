extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Idle")


func enter():
	velocity = Vector2.ZERO
	animate()
