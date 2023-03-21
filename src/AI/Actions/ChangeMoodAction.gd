extends ActionLeaf

export(int, "None", "Reserved", "Defensive", "Angry", "Curious", "Predatory", "Determined") var mood_to_change_to = -1


func tick(actor, blackboard):
	# print(get_path())
	assert(mood_to_change_to != 0)
	actor.mood = mood_to_change_to
	return SUCCESS
