extends "OnGroundState.gd"

var in_action_proximity
var hurtbox

export(int) var MAX_SPEED = 280

var existing_input_direction


func enter():
	velocity = Vector2()
	in_action_proximity = _options.get("in_action_proximity")
	animate()


func animate():
	get_animation_state().travel(get_name())


func handle_input(event):
	var current_move_type = get_parent().current_move_type

	var in_action: bool = current_move_type != "Walk"

	if in_action and event.is_action_pressed("ui_roll"):
		return emit_signal("finished", "Roll")

	if event.is_action_pressed("ui_sit"):
		return emit_signal("finished", "Sit")

	if in_action_proximity or not in_action:
		return

	if event.is_action_pressed("ui_attack"):
		return _attack()


func update(delta):
	var input_direction = get_input_direction()

	if input_direction != Vector2.ZERO:
		# TODO only update look direction if it changes...
		owner.update_look_direction(input_direction)

		animate()
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	var collision = owner.move(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.normal)

	if velocity == Vector2.ZERO:
		emit_signal("finished", "Idle")


func play_footstep():
	return


func _attack():
	var current_weapon_equipped = _options.current_weapon_equipped

	if current_weapon_equipped == "None":
		return emit_signal("finished", "Attack_1")

	var state_to_go_to: String = get_parent().weapon_attack_state_map.get(current_weapon_equipped)

	return emit_signal("finished", state_to_go_to)
