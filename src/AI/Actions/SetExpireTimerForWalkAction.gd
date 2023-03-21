extends ActionLeaf


func tick(actor, blackboard):
	var timer: Timer = actor.walk_expired_timer
	timer.one_shot = true
	timer.stop()
	var wait_duration = blackboard.get("move_duration") + get_process_delta_time()
	timer.start(wait_duration)
	return SUCCESS
