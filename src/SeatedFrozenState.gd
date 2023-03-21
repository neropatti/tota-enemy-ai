extends "OnGroundState.gd"

var timer: Timer

var seated_movements = ["SeatedLookLeft", "SeatedLookRight", "SeatedYawn", "SeatedLeanBack"]


func animate():
	get_animation_state().travel(get_name())


func enter():
	animate()
	timer = owner.get_timer()
	timer.connect("timeout", self, "_on_seated_cooldown")
	start_timer()


func start_timer():
	var time_to_play_random_movement = rand_range(5, 10)
	timer.start(time_to_play_random_movement)


func _on_seated_cooldown():
	timer.stop()
	var random_movement = rand_range(0, seated_movements.size() - 1)
	get_animation_state().travel(seated_movements[random_movement])


func _on_finished_other_movement():
	start_timer()


func exit():
	timer.disconnect("timeout", self, "_on_seated_cooldown")
	timer.stop()
	owner.update_look_direction(Vector2.DOWN)
