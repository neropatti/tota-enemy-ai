extends "OnGroundState.gd"

export(int) var MAX_SPEED = 100
export(int) var STAMINA_COST = 20
export(String) var next_state = "AttackAxe_2"
export(bool) var input_unlocked: bool = false
export(bool) var has_pressed: bool = false

var timer: Timer
var input_direction: Vector2 = Vector2.ZERO


func enter():
	velocity = Vector2()
	input_direction = get_input_direction()
	animate()
	owner.sound_fx.attack_axe()
	timer = owner.get_timer()
	timer.connect("timeout", self, "_on_attack_cooldown_timeout")
	start_attack_cooldown()
	Events.emit_signal("player_used_stamina", STAMINA_COST)


func exit():
	timer.stop()
	owner.sound_fx.stop_attack_axe()
	input_direction = Vector2.ZERO
	input_unlocked = false
	timer.disconnect("timeout", self, "_on_attack_cooldown_timeout")


func animate():
	get_animation_state().travel(get_name())


func on_attack_finished():
	emit_signal("finished", "Idle")


func start_attack_cooldown():
	timer.start(0.2)


func _on_attack_cooldown_timeout():
	timer.stop()
	input_unlocked = true


func handle_input(event):
	if input_unlocked and event.is_action_released("ui_attack"):
		input_unlocked = false
		emit_signal("finished", next_state)


func update(delta):
	if input_direction != Vector2.ZERO:
		owner.update_look_direction(input_direction)
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	owner.move(velocity * delta)
