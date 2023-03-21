extends KinematicBody2D

signal position_changed(new_position)
signal died

var look_direction = Vector2(0, 1) setget set_look_direction


func set_look_direction(value):
	look_direction = value


func set_active():
	set_process_input(true)
	set_process(true)


func set_inactive():
	set_process_input(false)
	set_process(false)


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value
	emit_signal("died")


func take_damage_from(_damage_source):
	pass  #@todo


func reset(target_global_position):
	global_position = target_global_position
