extends "OnGroundState.gd"

export(int) var MAX_SPEED = 300

var look_direction: Vector2
var current_charge_attack = 0.0
var timer: Timer


func enter():
	look_direction = owner.get_look_direction()
	current_charge_attack = owner.get_current_charge_attack()
	velocity = velocity.move_toward(look_direction * MAX_SPEED, ACCELERATION * 1.5)
	animate()
	owner.hide_charge_bar()
	owner.sound_fx.release_spear()
	timer = owner.get_timer()
	timer.connect("timeout", self, "_on_ran_distance")
	var total_run_time = 0.01 * current_charge_attack
	print("total run time " + str(total_run_time))
	timer.start(total_run_time)


func exit():
	timer.stop()
	timer.disconnect("timeout", self, "_on_ran_distance")
	owner.sound_fx.stop_release_spear()


func animate():
	get_animation_state().travel(get_name())


func handle_input(_event: InputEvent):
	return


func _on_ran_distance():
	timer.stop()
	emit_signal("finished", "AttackSpear_3")


func update(delta):
	velocity = velocity.move_toward(look_direction * MAX_SPEED, ACCELERATION * 1.5)
	var collision = owner.move(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.normal)
