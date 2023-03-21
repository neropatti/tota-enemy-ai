extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var is_idle: bool = actor.is_idle()

	if is_idle:
		return SUCCESS

	return FAILURE
