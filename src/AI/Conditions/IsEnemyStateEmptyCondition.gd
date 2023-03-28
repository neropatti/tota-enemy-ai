extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var blackboard_state = blackboard.get("state")
	
	if blackboard_state == null:
		return SUCCESS
	
	return FAILURE
