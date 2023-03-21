extends ActionLeaf


func tick(actor, blackboard):
	var i = blackboard.get("i")
	if i == null:
		i = 0
	print("\n-----" + get_parent().get_name() + " Iteration: " + str(i) + "\n")
	i = i + 1
	blackboard.set("i", i)

	if i == 5 and get_parent().get_name() == "Defensive":
		var stop

	return SUCCESS
