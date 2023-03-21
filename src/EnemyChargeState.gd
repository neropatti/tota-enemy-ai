extends "OnGroundState.gd"

export(int) var MAX_SPEED = 400
export(int) var DISTANCE_TO_STOP_CHARGING = 30

var locked_target_position = null
var has_finished = false
var enemy_position
var target_position: Vector2
var current_point
var speed = 50
var current_it = 0
var knockback = Vector2.ZERO
var collision: KinematicCollision2D


func animate():
	get_animation_state().travel(get_name())
	owner.get_node("Audio").get_node("AkCharge").post_event()


func enter():
	animate()
	has_finished = false
	var controller = owner.get_controller()
	target_position = controller.get_target_position()
	enemy_position = owner.global_position


func on_finished_charge():
	pass


func update(delta):
	if has_finished:
		return

	enemy_position = owner.global_position

	var distance_between = enemy_position.distance_to(target_position)

	if distance_between < DISTANCE_TO_STOP_CHARGING:
		has_finished = true
		return emit_signal("finished", "Attack")

	var direction_to_go = enemy_position.direction_to(target_position)

	velocity = velocity.move_toward(direction_to_go, ACCELERATION * delta)

	var has_collision: KinematicCollision2D = owner.move(velocity * ACCELERATION * delta)

	if has_collision:
		has_finished = true
		collision = has_collision
		var collider_name: String = collision.collider.name

		velocity = velocity.bounce(collision.normal)

		if ["TileMap"].has(collider_name):
			return emit_signal("finished", "WalkBack")

		elif ["Player"].has(collider_name):
			return emit_signal("finished", "Attack")

		else:
			return emit_signal("finished", "Bounce")

#	if velocity == Vector2.ZERO:
#		emit_signal('finished', 'Cooldown')
