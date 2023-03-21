extends "OnGroundState.gd"

const DISTANCE_TO_STOP_CHARGING = 10

var enemy_position
var walk_back_position
var has_finished


func animate():
	get_animation_state().travel("Walk")


func enter():
	has_finished = false
	walk_back_position = owner.original_allocated_position
	var controller = owner.get_controller()
	enemy_position = owner.global_position
	animate()


func update(delta):
	enemy_position = owner.global_position

	var distance_between = enemy_position.distance_to(walk_back_position)

	if distance_between < DISTANCE_TO_STOP_CHARGING:
		has_finished = true
		return emit_signal("finished", "Idle")

	var direction_to_go = enemy_position.direction_to(walk_back_position)

	velocity = velocity.move_toward(direction_to_go, ACCELERATION * delta)

	owner.move(velocity)
