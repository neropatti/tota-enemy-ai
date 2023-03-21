extends ActionLeaf


func tick(_actor, blackboard):
	# print(get_path())
	blackboard.set("ready_to_charge", null)
	return SUCCESS
