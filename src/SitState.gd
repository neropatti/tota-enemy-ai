extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())
	owner.get_node("Audio").get_node("AkSit").post_event()


func on_seated():
	emit_signal("finished", "SeatedIdle")


func enter():
	animate()
	owner.update_look_direction(Vector2.DOWN)


func exit():
	pass


func _on_HurtBox_area_entered(area):
	emit_signal("finished", "Hurt")
