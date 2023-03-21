extends "OnGroundState.gd"


func animate():
	get_animation_state().travel("Attack")
	owner.get_node("Audio").get_node("AkAttack").post_event()


func enter():
	animate()


func on_finished_attack():
	var chance_another_attack = randi() % 100 + 1
	if chance_another_attack >= 60:
		print("another attack")
		emit_signal("finished", "PreCharge")
	else:
		print("cooldown enemy")
		emit_signal("finished", "Cooldown")


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 10) * delta)

	var collision = owner.move(velocity)

	if collision:
		velocity = velocity.bounce(collision.normal)
