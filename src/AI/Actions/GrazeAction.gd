extends ActionLeaf

var started_grazing := false


func tick(actor, blackboard):
	if actor.is_grazing():
		return RUNNING
	if started_grazing:
		started_grazing = false
		return SUCCESS
	started_grazing = true
	actor.graze()
	return RUNNING
