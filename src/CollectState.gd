extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Collect")


func enter():
	owner.get_node("Audio").get_node("AkPickItem").post_event()
	animate()


func _on_collected():
	emit_signal("finished", "Idle")


func update(_delta):
	pass
