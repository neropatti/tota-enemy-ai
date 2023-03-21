extends Area2D

onready var collision = $CollisionShape2D


func enable():
	collision.set_deferred("disabled", false)


func disable():
	collision.set_deferred("disabled", true)
