extends "OnGroundState.gd"

export(int) var DISTANCE_TO_STOP_CHARGING = 20

var controller
var collision
var target_position
var enemy_position
var has_finished
var distance_between
var direction_to_go


func animate():
	get_animation_state().travel("Attack")
	owner.get_node("Audio").get_node("AkAttack").post_event()


func enter():
	has_finished = false
	animate()
	controller = owner.get_controller()
	target_position = controller.get_target_position()
	enemy_position = owner.global_position
	distance_between = enemy_position.distance_to(target_position)
	direction_to_go = enemy_position.direction_to(target_position)


func on_finished_attack():
	emit_signal("finished", "Cooldown")


func update(delta):
	velocity = velocity.move_toward(direction_to_go, (distance_between) * delta)

	var has_collision: KinematicCollision2D = owner.move(velocity * 300 * delta)

	if has_collision:
		collision = has_collision
		var collider_name: String = collision.collider.name
		velocity = velocity.bounce(collision.normal)
