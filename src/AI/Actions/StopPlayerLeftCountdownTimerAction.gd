extends ActionLeaf


func tick(actor, blackboard: Object):
	# print(get_path())
	var player_left_timer: Timer = actor.player_left_timer
	player_left_timer.stop()
	blackboard.set("player_left_timer_started", null)
	return SUCCESS
