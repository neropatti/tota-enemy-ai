extends "OnGroundState.gd"

var current_move_type
var in_action_proximity
var hurtbox: Area2D


func animate():
	get_animation_state().travel(get_name())


func enter():
	velocity = Vector2.ZERO
	owner.hide_charge_bar()
	owner.set_silhouette(true)
	animate()


func handle_input(event):
	current_move_type = get_parent().current_move_type
	in_action_proximity = get_parent().in_action_proximity

	var in_action: bool = current_move_type != "Walk"

	if in_action and event.is_action_pressed("ui_roll"):
		return emit_signal("finished", "Roll")

	if event.is_action_pressed("ui_sit"):
		return emit_signal("finished", "Sit")

	if in_action_proximity or not in_action:
		return

	if event.is_action_pressed("ui_attack"):
		return _attack()


func _attack():
	var current_weapon_equipped = _options.current_weapon_equipped

	if current_weapon_equipped == "None":
		return emit_signal("finished", "Attack_1")

	var state_to_go_to: String = get_parent().weapon_attack_state_map.get(current_weapon_equipped)

	return emit_signal("finished", state_to_go_to)


func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", get_parent().current_move_type)
