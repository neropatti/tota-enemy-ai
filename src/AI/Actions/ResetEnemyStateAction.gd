extends ActionLeaf


func tick(_actor, blackboard):
	# print(get_path())
	blackboard.set("state", null)
	return SUCCESS
