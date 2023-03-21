extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func play_sound():
	owner.get_node("Audio").get_node("AkInteractTent").post_event()


func enter():
	owner.update_look_direction(Vector2.UP)
	animate()
	play_sound()


func exit():
	pass
