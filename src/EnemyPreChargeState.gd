extends "OnGroundState.gd"

var controller


func animate():
	get_animation_state().travel("PreCharge")
	owner.get_node("Audio").get_node("AkIdle").stop_event()
	owner.get_node("Audio").get_node("AkPrecharge").post_event()


func enter():
	controller = owner.get_controller()
	animate()
	acknowledge_player()


func acknowledge_player():
	var target_position = controller.get_target_position()

	if controller.has_detected_player_recently():
		return

	if owner.can_see_player and target_position != null:
		controller.show_alert_found_player()
	elif target_position != null:
		controller.show_alert_heard_noise()


func on_precharge_finished():
	var target_position = controller.get_target_position()
	if owner.can_see_player and target_position != null:
		emit_signal("finished", "Charge")
	else:
		emit_signal("finished", "Idle")


func update(_delta):
	pass
