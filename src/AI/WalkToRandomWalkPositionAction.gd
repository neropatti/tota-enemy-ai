extends ActionLeaf

export(String) var blackboard_key = "random_enemy_position"


func tick(actor, blackboard):
	var random_enemy_position = blackboard.get("random_enemy_position")
	actor.walk(random_enemy_position)
	return SUCCESS
