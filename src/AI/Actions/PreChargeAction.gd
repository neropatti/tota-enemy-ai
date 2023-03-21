extends ActionLeaf


func tick(actor, _blackboard):
	# print(get_path())
	actor.pre_charge()
#	actor.audio.play_precharge()
	return SUCCESS
