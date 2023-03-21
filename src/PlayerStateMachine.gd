extends "StateMachine.gd"

var in_action_proximity: bool = false
var attack_index = 0
var current_look_direction = Vector2.DOWN
var current_attack_charge: float = 0.0
var supported_weapons = {"None": "None", "SmallAxe": "SmallAxe", "Spear": "Spear"}
var weapon_attack_state_map: Dictionary = {"SmallAxe": "AttackAxe_1", "Spear": "AttackSpear_1"}
var supported_move_types = {"WALK": "Walk", "RUN": "Run"}
var current_move_type = supported_move_types.WALK
var current_weapon_equipped = supported_weapons.None


func _ready():
	init()
	Events.connect("take_collectable_requested", self, "_on_take_collectable_requested")
	Events.connect("start_campfire_success", self, "_on_start_campfire_success")
	Events.connect("opened_inventory", self, "_on_opened_inventory")
	Events.connect("closed_inventory", self, "_on_closed_inventory")
	Events.connect("opened_storage", self, "_on_entered_menu")
	Events.connect("opened_crafting", self, "_on_entered_menu")
	Events.connect("closed_storage", self, "_on_exited_menu")
	Events.connect("closed_crafting", self, "_on_exited_menu")


func init():
	for state in get_children():
		states_map[state.name] = state
		if not state.is_connected("finished", self, "_change_state"):
			state.connect("finished", self, "_change_state")
	.init()


func update_look_direction(input_direction: Vector2):
	current_look_direction = input_direction
	_set_blend_param_for_state("Idle", input_direction)  # always update idle
	_set_blend_param_for_state(current_state.name, input_direction)


func _set_blend_param_for_state(state_name: String, input_direction: Vector2):
	var anim_tree: AnimationTree = owner.get_animation_tree()
	var blend_pos_path = "parameters/" + state_name + "/blend_position"
	var blend_pos = anim_tree.get(blend_pos_path)
	if blend_pos != null:
		anim_tree.set(blend_pos_path, input_direction)


func currently_hurting():
	return current_state != null and current_state.name == "Hurt" or current_state.name == "Die"


func reset_weapon():
	current_weapon_equipped = supported_weapons.None


func _on_entered_menu():
	_change_state("Frozen")


func _on_exited_menu():
	_change_state("Idle")


func _on_take_collectable_requested(_item_id: String):
	_change_state("Collect")


func _on_start_campfire_success():
	_change_state("Collect")


func _on_opened_inventory():
	_change_state("BagOpen")
	_set_blend_param_for_state("BagClose", current_look_direction)


func _on_closed_inventory():
	_change_state("Idle")


func _unhandled_input(event) -> void:
	if current_state:
		current_state.handle_input(event)


func _change_state(state_name, _options: Dictionary = {}):
	print("PLAYER STATE: " + state_name)
	._change_state(state_name, _set_default_options(_options))
	_set_blend_param_for_state(state_name, current_look_direction)


func _set_default_options(_options):
	_options.current_weapon_equipped = current_weapon_equipped
	_options.current_move_type = current_move_type
	_options.in_action_proximity = in_action_proximity
	return _options


func take_damage(_area):
	var state_name = get_current_state_name()
	if ["Roll", "Frozen", "Hurt", "Die"].has(state_name):
		return

	_change_state("Hurt")
