extends ActionLeaf

export(float) var random_range: float = 20

func tick(actor, blackboard):
	randomize()
	
	var player_position: Vector2 = actor.player_in_predatory_zone.position
	var x_range: float = rand_range(-random_range, random_range)
	var y_range: float = rand_range(-random_range, random_range)
	var random_around: Vector2 = Vector2(player_position.x + x_range, player_position.y + y_range)
	
	actor.set_target_location(random_around)
	blackboard.set("player_position", random_around)
	return SUCCESS
