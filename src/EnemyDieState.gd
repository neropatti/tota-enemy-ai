extends "OnGroundState.gd"

const player_id: String = "Player"
var show_method_to_fire = "show_alert_action"
var hide_method_to_fire = "hide_alert_action"
var is_in_zone = false
var controller


func animate():
	get_animation_state().travel("Die")
	owner.get_node("Audio").get_node("AkDeath").post_event()


func enter():
	animate()
	controller = owner.get_controller()
	get_parent().has_died = true
	Events.emit_signal("enemy_killed", owner.get_name())


func on_finished_death():
	controller.allow_meat_collection()


func dispose_of():
	controller.dispose_enemy()


func update(_delta):
	pass


func _on_DeadCollectZone_body_entered(body):
	if body.name != player_id:
		return
	if body.has_method(show_method_to_fire):
		is_in_zone = true
		body.show_alert_action("attack", "Skin")


func _on_DeadCollectZone_body_exited(body):
	if body.name != player_id:
		return
	if body.has_method(hide_method_to_fire):
		body.hide_alert_action()
		is_in_zone = false
