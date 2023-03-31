extends ConditionLeaf

func tick(actor, blackboard):
	if actor.player_in_predatory_zone != null:
		return SUCCESS
	
	return FAILURE
