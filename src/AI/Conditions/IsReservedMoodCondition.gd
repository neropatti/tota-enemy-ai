extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.is_mood_reserved():
		return SUCCESS

	return FAILURE
