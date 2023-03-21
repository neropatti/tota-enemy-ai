extends "OnGroundState.gd"

const MAX_SPEED = 1
const FALL_DAMAGE = 50

var direction_to_hole
var has_finished: bool = false


func animate():
	get_animation_state().travel(get_name())


func enter():
	has_finished = false
	animate()
	direction_to_hole = _options.get("hole_position")
	velocity = velocity.move_toward(direction_to_hole, MAX_SPEED)


func on_finished_fall():
	has_finished = true
	Events.emit_signal("player_fell_down_hole", FALL_DAMAGE)


func update(_delta):
	if has_finished:
		return
	velocity = velocity.move_toward(direction_to_hole * 10, _delta)
	owner.move(velocity)
