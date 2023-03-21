extends "StateMachine.gd"

var current_look_direction = -1
var has_died = false


func _ready():
	set_process_input(false)
	init()


func _exit_tree():
	for state in get_children():
		if not state.is_connected("finished", self, "_change_state"):
			state.disconnect("finished", self, "_change_state")


func init():
	for state in get_children():
		states_map[state.name] = state
		if not state.is_connected("finished", self, "_change_state"):
			state.connect("finished", self, "_change_state")
	.init()


func update_look_direction(direction: int):
	current_look_direction = direction
	if current_state:
		_set_blend_param_for_state("Idle", direction)  # always update idle
		_set_blend_param_for_state("Graze", direction)
		_set_blend_param_for_state(current_state.name, direction)


func _set_blend_param_for_state(state_name: String, direction: int):
	var anim_tree: AnimationTree = owner.controller.get_animation_tree()
	var blend_pos_path = "parameters/" + state_name + "/blend_position"
	var blend_pos = anim_tree.get(blend_pos_path)
	if blend_pos != null:
		anim_tree.set(blend_pos_path, direction)


func is_idle() -> bool:
	var name: String = current_state.name
	return name == "Idle"


func is_pre_charging() -> bool:
	var name: String = current_state.name
	return name == "PreCharge"


func is_charging() -> bool:
	return current_state.name == "Charge"


func is_running() -> bool:
	return is_charging()


func is_attacking() -> bool:
	return current_state.name == "Attack"


func is_walking() -> bool:
	return current_state.name == "Walk"


func is_grazing() -> bool:
	return current_state.name == "Graze"


# @TODO DEPRECATE
func currently_hurting() -> bool:
	return is_hurting()


func is_hurting() -> bool:
	if current_state == null:
		return false
	return current_state.name == "Hurt"


func _change_state(state_name, _options: Dictionary = {}):
	print("ENEMY STATE: " + state_name)
	._change_state(state_name, _options)
