extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	var player_position = actor.player.position
	actor.set_target_location(player_position)
	blackboard.set("player_position", player_position)
	return SUCCESS
