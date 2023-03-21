extends Area2D

export(int) var damage_inflicted = 50

onready var collision = $CollisionShape2D


func enable():
	collision.set_deferred("disabled", false)


func disable():
	collision.set_deferred("disabled", true)


func _ready():
	enable()
