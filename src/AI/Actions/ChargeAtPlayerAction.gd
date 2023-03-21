extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	actor.move_towards_target_location()

	return SUCCESS
