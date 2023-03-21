extends "OnGroundState.gd"

enum STATES { IS_CHARGING_ATTACK, CHARGE_ATTACK_COMPLETE }

var existing_input_direction: Vector2
var current_state = STATES.IS_CHARGING_ATTACK
var current_charge: float = 0


func enter():
	current_charge = 0
	owner.show_charge_bar()
	owner.sound_fx.charge_spear()
	animate()


func exit():
	current_charge = 0
	current_state = STATES.IS_CHARGING_ATTACK
	owner.sound_fx.stop_charge_spear()


func animate():
	get_animation_state().travel(get_name())


func handle_input(event: InputEvent):
	if current_state == STATES.CHARGE_ATTACK_COMPLETE:
		return

	if event.is_action_pressed("ui_attack"):
		current_state = STATES.IS_CHARGING_ATTACK
	elif event.is_action_released("ui_attack"):
		current_state = STATES.CHARGE_ATTACK_COMPLETE


func update(delta):
	var input_direction = get_input_direction()

	if input_direction != Vector2.ZERO and input_direction != existing_input_direction:
		owner.update_look_direction(input_direction)

	match current_state:
		STATES.IS_CHARGING_ATTACK:
			current_charge = clamp(current_charge + 1, 0.0, 100.0)
			owner.update_charge_bar(current_charge)
		STATES.CHARGE_ATTACK_COMPLETE:
			Events.emit_signal("player_used_stamina", ceil(current_charge / 3))
			owner.set_current_charge_attack(current_charge)
			set_process(false)
			emit_signal("finished", "AttackSpear_2")
