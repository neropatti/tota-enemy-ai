extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var player_left_timer: Timer = actor.player_left_timer
	var time_left = player_left_timer.time_left
	if time_left > 0:
		return FAILURE
	return SUCCESS
