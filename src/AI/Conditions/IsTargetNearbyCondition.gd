extends ConditionLeaf


func tick(actor, _blackboard):
	# print(get_path())
	if actor.player != null or (actor.is_mood_predatory() and actor.player_in_predatory_zone != null):
		return SUCCESS
	return FAILURE
