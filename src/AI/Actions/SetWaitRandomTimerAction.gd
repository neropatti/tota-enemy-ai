extends ActionLeaf

enum { IDLE, STARTED, IS_RUNNING, FINISHED }

export(float) var wait_duration = 250
export(float) var wait_duration_multiplier = 2

var state: int = IDLE
var timer: Timer = null
var timer_finished: bool = false


func tick(actor, blackboard):
	# print(get_path())
	if timer == null:
		timer = actor.wait_timer

	if state == STARTED:
		return RUNNING

	if state == FINISHED:
		state = IDLE
		return SUCCESS

	state = STARTED
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")

	var wait_duration_final := rand_range(wait_duration, wait_duration * wait_duration_multiplier)
	timer.start(wait_duration_final)
	return RUNNING


func _on_timeout():
	timer.disconnect("timeout", self, "_on_timeout")
	timer.stop()
	state = FINISHED
