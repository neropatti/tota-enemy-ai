extends Node

onready var attack_axe_light = $AkAttackLight
onready var attack_axe_heavy = $AkAttackHeavy
onready var attack_spear_1 = $AkSpear1
onready var attack_spear_2 = $AkSpear2
onready var attack_spear_3 = $AkSpear3
onready var _roll = $AkRoll
onready var footstep = $AkFootstep

const SOIL_RTPC_NAME: String = "RTPC_Soil"
const DEFAULT_TERRAIN: int = 0


func _ready():
	_update_rtpc(SOIL_RTPC_NAME, DEFAULT_TERRAIN)  # default walk terrain to 0 (Grass)


func attack_one():
	attack_axe()


func attack_two():
	attack_axe()


func attack_three():
	attack_axe_heavy()


func attack_axe():
	attack_axe_light.post_event()


func stop_attack_axe():
	attack_axe_light.stop_event()


func attack_axe_heavy():
	attack_axe_heavy.post_event()


func charge_spear():
	attack_spear_1.post_event()


func stop_charge_spear():
	attack_spear_1.stop_event()


func release_spear():
	attack_spear_2.post_event()


func stop_release_spear():
	attack_spear_2.stop_event()


func spear_attack():
	attack_spear_3.post_event()


func roll():
	_roll.post_event()


func play_footstep(terrain = null):
	footstep.post_event()
	if terrain != null:
		_update_rtpc(SOIL_RTPC_NAME, terrain)


func _update_rtpc(param_name = false, param_value = false):
	Wwise.set_rtpc(param_name, param_value, null)
