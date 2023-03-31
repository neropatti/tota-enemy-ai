extends ActionLeaf


func tick(actor, blackboard):
	actor.move_towards_target_location()
	return SUCCESS
