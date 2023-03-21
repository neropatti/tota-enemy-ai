extends ConditionLeaf


func tick(actor, blackboard):
	print(get_name())
	if actor.is_mood_angry():
		return SUCCESS

	return FAILURE
