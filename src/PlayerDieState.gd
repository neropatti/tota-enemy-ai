extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Die")


func enter():
	if get_parent().current_state.name == "Fall":
		return
#	owner.get_node("Audio").get_node("AkAdiraDeath").post_event()
#	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.RTPC_MUSIC, 100, null)
#	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.RTPC_MUSIC_COMBAT, 0, null)
	animate()


func on_died():
	Events.emit_signal("player_died")
