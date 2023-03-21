extends ActionLeaf

var started: bool = false


func tick(actor, blackboard):
	var timer: Timer = actor.walk_timer
	if started and timer.is_stopped():
		return SUCCESS
	else:
		timer.start()
	return RUNNING
