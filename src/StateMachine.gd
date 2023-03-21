extends Node
class_name StateMachine

signal state_changed(current_state)

export(bool) var active = false setget set_active

var states_map = {}
var states_stack = []
var current_state = null


func _ready():
	init()
	if active:
		start()


func init() -> void:
	var first_child = get_child(0)
	states_stack.push_front(first_child)
	current_state = first_child


func start() -> void:
	current_state.enter()
	set_active(true)


func stop() -> void:
	set_active(false)


func set_active(value) -> void:
	active = value
	set_physics_process(value)
	set_process_input(value)
	if not active:
		reset()
	else:
		init()


func reset() -> void:
	states_stack = []
	current_state = null


func _unhandled_input(event) -> void:
	if current_state:
		current_state.handle_input(event)


func _physics_process(delta) -> void:
	if current_state:
		current_state.update(delta)


func _on_animation_finished(anim_name) -> void:
	if not active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state_name, _options: Dictionary = {}) -> void:
	if not active:
		return
	current_state.exit()
	current_state = get_state(state_name)
	emit_signal("state_changed", current_state)
	current_state._options = _options
	current_state.enter()


func get_state(state_name: String):
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	return states_stack[0]


func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""


func has_current_state(state_name: String) -> bool:
	return current_state and current_state.name == state_name
