extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("PassOut")


func enter():
	if get_parent().current_state.name == "Fall":
		return
	animate()


func on_passed_out():
	Events.emit_signal("player_passed_out")
