extends ActionLeaf


func tick(actor, blackboard):
	if not actor.is_walking():
		actor.walk()
	actor.move_towards_target_location()

	if actor.walk_expired_timer.time_left == 0:
		return SUCCESS

	if actor.arrived_at_target_location():
		return SUCCESS

	return RUNNING
