extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	blackboard.set("state", "attacked")
	return SUCCESS
