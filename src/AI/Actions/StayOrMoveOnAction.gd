extends ActionLeaf


func tick(actor, blackboard):
	var stay_or_move_on = randi() % 10
	if stay_or_move_on >= 5:
		return FAILED

	return SUCCESS
