extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func enter():
	animate()


func _on_finished_grazing():
	emit_signal("finished", "Idle")
