extends "OnGroundState.gd"

export(int) var MAX_SPEED = 400

const STAMINA_COST = 30

var max_speed = MAX_SPEED
var acceleration = ACCELERATION
var roll_vector = Vector2()


func animate():
	get_animation_state().travel("Roll")


func enter():
	var look_direction = owner.get_look_direction()
	acceleration = ACCELERATION

	velocity = velocity.move_toward(look_direction * max_speed, acceleration / 2)
	animate()
	owner.sound_fx.roll()
	Events.emit_signal("player_used_stamina", STAMINA_COST)


func apply_move_through_enemies():
	pass


func revert_move_through_enemies():
	pass


func _on_roll_finished():
	emit_signal("finished", "Idle")


func update(delta):
	if roll_vector != Vector2.ZERO:
		velocity = velocity.move_toward(roll_vector * max_speed, (acceleration * 2) * delta)

	owner.move(velocity * delta)
