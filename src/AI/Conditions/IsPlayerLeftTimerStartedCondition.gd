extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var has_started_already = blackboard.get("player_left_timer_started")
	if has_started_already != null:
		return SUCCESS
	return FAILURE
