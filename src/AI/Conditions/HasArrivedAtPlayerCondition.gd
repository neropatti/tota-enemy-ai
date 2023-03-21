extends ConditionLeaf

export(float) var proximity_distance = 50.0


func tick(actor, blackboard):
	# print(get_path())
	var player_position = blackboard.get("player_position")
	var proximity_distance_left = actor.global_position.distance_to(player_position)
	var in_close_proximity = proximity_distance_left < proximity_distance

	if in_close_proximity or actor.arrived_at_target_location():
		return SUCCESS

	return FAILURE
