extends "Actor.gd"
class_name Player

const HURT_COOLDOWN_PERIOD: float = 1.0
const KNOCKBACK_FRICTION = 100
const PLAYER_LAYER_BIT = 1
const PLAYER_HURTBOX_LAYER_BIT = 3
const HOUR_FIREFLIES_START = 20
const HOUR_FIREFLIES_END = 3
const HOUR_PLAYER_PASSED_OUT = 3

onready var shadow = $Shadow
onready var mask = $Mask
onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var state_machine = $StateMachine
onready var alert_bubble = $AlertBubble
onready var alert_action = $AlertAction
onready var animation_tree: AnimationTree = $AnimationTree
onready var hurtbox: Area2D = $HurtBox
onready var hitbox: Area2D = $HitBoxPivot/HitBox
onready var charge_bar: ProgressBar = $ChargeBar
onready var stat_value_changed = $StatValueChange
onready var sound_fx = $Audio
onready var freeze_timer = $FreezeTimer
onready var timer = $Timer
onready var controller = $Controller
onready var fireflies = $FireFlies

var knockback := Vector2.ZERO
var in_action_proximity: bool = false


func _ready():
	state_machine.start()
	alert_action.visible = false
	alert_bubble.visible = false
	animation_tree.active = true
	_add_listeners()
	_setup_audio()
	set_motion_run()


func _add_listeners():
	Events.connect("player_killed", self, "_on_player_killed")
	Events.connect("player_stamina_empty", self, "_on_no_stamina_left")
	Events.connect("player_stamina_restored", self, "_on_stamina_restored")
	Events.connect("equip_item_success", self, "_on_item_equipped")
	Events.connect("entered_pond_replenish_success", self, "_on_entered_pond_replenish_success")
	Events.connect("speak_to_torion_requested", self, "_on_speak_to_torion_requested")
	Events.connect("finished_dialogue", self, "_on_finished_dialogue")
	Events.connect("moving_to_next_level_coords", self, "_on_moving_to_next_level_coords")
	Events.connect("day_hour_changed", self, "_on_day_hour_changed")
	hurtbox.connect("area_entered", self, "_on_hurt")
	freeze_timer.connect("timeout", self, "_on_freeze_finished")


func _remove_listeners():
	Events.disconnect("player_killed", self, "_on_player_killed")
	Events.disconnect("player_stamina_empty", self, "_on_no_stamina_left")
	Events.disconnect("player_stamina_restored", self, "_on_stamina_restored")
	Events.disconnect("equip_item_success", self, "_on_item_equipped")
	Events.disconnect("entered_pond_replenish_success", self, "_on_entered_pond_replenish_success")
	Events.disconnect("speak_to_torion_requested", self, "_on_speak_to_torion_requested")
	Events.disconnect("finished_dialogue", self, "_on_finished_dialogue")
	Events.disconnect("moving_to_next_level_coords", self, "_on_moving_to_next_level_coords")
	Events.disconnect("day_hour_changed", self, "_on_day_hour_changed")
	hurtbox.disconnect("area_entered", self, "_on_hurt")
	freeze_timer.disconnect("timeout", self, "_on_freeze_finished")


func _setup_audio():
	return
#	Wwise.register_game_obj(self, self.get_name())


func _get_controller():
	return controller


func freeze(duration: float = 0.3):
	freeze_timer.start(duration)
	disable()


func _on_freeze_finished():
	freeze_timer.stop()
	enable()


func set_motion_walk():
	var move_type = state_machine.supported_move_types.WALK
	state_machine.current_move_type = move_type


func set_motion_run():
	var move_type = state_machine.supported_move_types.RUN
	state_machine.current_move_type = move_type


func disable():
	self.set_collision_layer_bit(PLAYER_LAYER_BIT, false)
	state_machine._change_state("Frozen")


func enable():
	self.set_collision_layer_bit(PLAYER_LAYER_BIT, true)
	state_machine._change_state("Idle")


func set_animation(animation_name):
	var playback = animation_tree.get("parameters/playback")
	if playback:
		playback.travel(animation_name)


func move(velocity):
	var collision = move_and_collide(velocity)
	if not collision:
		return
	return collision


func fall_down_hole(hole_position: Vector2):
	set_silhouette(false)
	shadow.visible = false
	state_machine._change_state("Fall", {"hole_position": hole_position})


func sit():
	state_machine._change_state("Sit")


func stood_frozen():
	state_machine._change_state("Frozen")


func look_to(_input_direction: Vector2, set_frozen: bool = false):
	if set_frozen:
		stood_frozen()
	state_machine.update_look_direction(_input_direction)


func seated_frozen():
	state_machine._change_state("SeatedFrozen")


func set_silhouette(_enabled: bool):
	var _mask = mask.get_material()
	var _sprite = sprite.get_material()


func get_animation_tree():
	return self.get_node("AnimationTree")


func hurt_cooldown():
	var hurtbox_collision = hurtbox.get_node("CollisionShape2D")
	hurtbox.set_collision_layer_bit(PLAYER_HURTBOX_LAYER_BIT, false)
	yield(get_tree().create_timer(HURT_COOLDOWN_PERIOD), "timeout")
	hurtbox.set_collision_layer_bit(PLAYER_HURTBOX_LAYER_BIT, true)


func get_timer():
	return timer


func update_look_direction(input_direction: Vector2):
	var dir = input_direction.normalized()
	state_machine.update_look_direction(dir)


func get_look_direction():
	return state_machine.current_look_direction


func get_state_name() -> String:
	return state_machine.get_current_state_name()


func get_in_water():
	state_machine._change_state("Swim")
	shadow.visible = false


func get_out_water():
	state_machine._change_state("Idle")
	shadow.visible = true


func show_alert(alert_type: String):
	alert_bubble.show_bubble(alert_type)


func hide_alert():
	alert_bubble.hide_bubble()


func show_alert_action(alert_type: String, label = "Take"):
	state_machine.in_action_proximity = true
	alert_action.show_alert_action(alert_type, label)


func hide_alert_action():
	state_machine.in_action_proximity = false
	alert_action.hide_alert_action()


func get_current_charge_attack() -> float:
	return state_machine.current_attack_charge


func set_current_charge_attack(charge_attack: float):
	state_machine.current_attack_charge = charge_attack


func show_charge_bar():
	charge_bar.visible = true


func hide_charge_bar():
	charge_bar.visible = false


func update_charge_bar(charge_value: float):
	charge_bar.value = charge_value


func take_knockback(area):
	var distance = global_position.direction_to(area.global_position)
	knockback = distance * KNOCKBACK_FRICTION


func take_damage(damage_inflicted):
	_trigger_hurt()
	stat_value_changed.lost_health(damage_inflicted)
	Events.emit_signal("player_taken_damage", damage_inflicted)


func respawn():
	state_machine._change_state("Respawn")


func _trigger_hurt():
	state_machine._change_state("Hurt")


func _on_speak_to_torion_requested():
	if is_in_inventory():
		return
	disable()


func _on_finished_dialogue():
	enable()


func _on_player_killed():
	_disable_collisions()
	state_machine._change_state("Die")
	state_machine.stop()
	_remove_listeners()
	set_physics_process(false)
	set_process_input(false)


func _disable_collisions():
	hurtbox.disable()
	hitbox.disable()


func _on_no_stamina_left():
	state_machine.current_move_type = state_machine.supported_move_types.WALK


func _on_stamina_restored():
	state_machine.current_move_type = state_machine.supported_move_types.RUN


func _on_item_equipped(item):
	state_machine.current_weapon_equipped = item.id


func _on_entered_pond_replenish_success():
	stat_value_changed.gained_health(100)


func _on_weapon_depleted():
	state_machine.reset_weapon()


func _on_moving_to_next_level_coords(
	current_level_coords: Vector2, next_level_coords: Vector2, next_level
):
	if next_level_coords == Vector2.ZERO:
		set_motion_walk()
	else:
		set_motion_run()


func _on_day_hour_changed(hour: int):
	if hour == HOUR_PLAYER_PASSED_OUT:
		_pass_out()
	elif hour >= HOUR_FIREFLIES_START or hour < HOUR_FIREFLIES_END:
		if not fireflies.is_showing():
			fireflies.fade_in()
	elif fireflies.is_showing():
		fireflies.fade_out()


func walk_into_tent():
	_remove_listeners()
	state_machine._change_state("WalkInside")
	_disable_collisions()
	state_machine.stop()
	set_physics_process(false)
	set_process_input(false)


func _pass_out():
	_remove_listeners()
	state_machine._change_state("PassOut")
	_disable_collisions()
	state_machine.stop()
	set_physics_process(false)
	set_process_input(false)


func _on_hurt(area: Area2D):
	if area.damage_inflicted <= 0 or state_machine.currently_hurting():
		return

	var actual_damage = rand_range(area.damage_inflicted / 2, area.damage_inflicted)

	take_knockback(area)
	take_damage(actual_damage)


func is_in_inventory() -> bool:
	return state_machine.has_current_state("BagOpen") or state_machine.has_current_state("BagClose")
