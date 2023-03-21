extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var is_too_close: bool = actor.in_danger_area()
	if is_too_close:
		return SUCCESS
	return FAILURE
