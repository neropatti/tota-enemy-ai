extends ActionLeaf

export(float) var stay_on_guard_duration := 5.0


func tick(actor, blackboard):
	# print(get_path())
	var player_left_timer: Timer = actor.player_left_timer
	player_left_timer.one_shot = true
	player_left_timer.start(stay_on_guard_duration)
	blackboard.set("player_left_timer_started", true)
	return SUCCESS
