extends ConditionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var ready_to_charge: bool = blackboard.get("ready_to_charge", false)

	if ready_to_charge:
		return SUCCESS

	return FAILURE
