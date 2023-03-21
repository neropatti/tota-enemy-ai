extends ActionLeaf


func tick(actor, blackboard):
	actor.idle()
	return SUCCESS
