extends Node2D

onready var label = $Label
onready var anim_player = $AnimationPlayer


func _ready():
	self.visible = false
	anim_player.connect("animation_finished", self, "_on_animation_finished")


func lost_health(damage: int):
	self.visible = true
	self.label.visible = true
	label.text = "-" + str(damage)
	anim_player.play("Damage")


func gained_health(health: int):
	self.visible = true
	self.label.visible = true
	label.text = "+" + str(health)
	anim_player.play("Restored")


func _on_animation_finished(_anim_name: String):
	self.visible = false
