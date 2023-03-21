extends "OnGroundState.gd"

export(NodePath) onready var shockwave = get_node(shockwave) as Node2D


func animate():
	get_animation_state().travel("Attack")
	owner.get_node("Audio").get_node("AkAttack").post_event()


func enter():
	animate()


func emit_shockwave():
	shockwave.visible = true
	shockwave.play()


func on_finished_attack():
	emit_signal("finished", "Cooldown")


func update(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION / 10) * delta)

	print(velocity)

	var collision = owner.move(velocity)

	if collision:
		velocity = velocity.bounce(collision.normal)
