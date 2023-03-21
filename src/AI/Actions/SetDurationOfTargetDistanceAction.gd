extends ActionLeaf


func tick(actor, blackboard):
	var distance = actor.global_position.distance_to(actor.get_target_location())
	var speed = actor.enemy_walk_speed

	blackboard.set("move_duration", (distance / speed) * 1.5)
	print("move duration: " + str(blackboard.get("move_duration")))

	return SUCCESS
