extends ActionLeaf

export(String) var blackboard_key = "random_enemy_position"


func tick(actor, blackboard):
	var mouse_position = get_viewport().get_mouse_position()
	blackboard.set(blackboard_key, mouse_position)
	return SUCCESS
