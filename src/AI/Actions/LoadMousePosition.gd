extends ActionLeaf

export(String) var blackboard_key = null


func tick(_actor, blackboard):
	assert(blackboard_key != null)
	var mouse_pos = get_viewport().get_mouse_position()
	blackboard.set(blackboard_key, mouse_pos)
	return SUCCESS
