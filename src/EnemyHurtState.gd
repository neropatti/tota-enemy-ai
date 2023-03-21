extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Hurt")
	owner.get_node("Audio").get_node("AkHurt").post_event()


func enter():
	animate()


func on_finished_hurt():
	emit_signal("finished", "Idle")


func update(_delta):
	pass
