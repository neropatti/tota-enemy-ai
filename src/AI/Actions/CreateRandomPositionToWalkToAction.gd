extends ActionLeaf


func tick(actor, blackboard: Object):
	var target_pos: Vector2 = actor.set_random_walk_to_position()

	actor.set_target_location(target_pos)
	blackboard.set("target_location", target_pos)

	return SUCCESS
