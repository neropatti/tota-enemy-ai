extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	actor.charge()
#	actor.audio.play_charge()
	return SUCCESS
