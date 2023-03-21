extends "State.gd"

var skipped_initial_close = false


func enter():
	var controller = owner.get_controller()
	controller.show()
	controller.collapse()
	controller.close_bag(skipped_initial_close)
	skipped_initial_close = true


func exit():
	pass


func handle_input(_event):
	pass
