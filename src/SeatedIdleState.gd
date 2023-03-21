extends "OnGroundState.gd"


func animate():
	get_animation_state().travel(get_name())


func enter():
	animate()


func exit():
	owner.get_node("Audio").get_node("AkStand").post_event()
	owner.update_look_direction(Vector2.DOWN)


func handle_input(event):
	if event.is_action_released("ui_sit"):
		emit_signal("finished", "Idle")


func _on_HurtBox_area_entered(area):
	emit_signal("finished", "Hurt")
