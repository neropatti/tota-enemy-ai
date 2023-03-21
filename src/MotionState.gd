extends "State.gd"


func get_input_direction():
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	return input_direction


func get_animation_tree():
	return owner.get_node("AnimationTree")


func get_animation_state():
	return self.get_animation_tree().get("parameters/playback")
