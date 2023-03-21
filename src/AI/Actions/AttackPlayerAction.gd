extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	actor.attack()
#	owner.audio.play_attack()
	return SUCCESS
