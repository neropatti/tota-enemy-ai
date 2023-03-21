extends ActionLeaf


func tick(actor, _blackboard):
	# print(get_path())
	actor.idle()
	return SUCCESS
