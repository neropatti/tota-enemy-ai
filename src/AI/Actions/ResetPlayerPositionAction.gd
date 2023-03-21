extends ActionLeaf


func tick(actor, blackboard: Object):
	# print(get_path())
	actor.idle()
	blackboard.set("player_position", null)
	return SUCCESS
