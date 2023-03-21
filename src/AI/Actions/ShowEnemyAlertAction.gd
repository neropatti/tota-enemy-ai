extends ActionLeaf


func tick(actor, blackboard):
	# print(get_path())
	actor.controller.show_alert_found_player()
	return SUCCESS
