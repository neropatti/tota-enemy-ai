extends ConditionLeaf


func tick(actor, _blackboard):
	# print(get_path())
	if actor.player != null:
		return SUCCESS

	return FAILURE
