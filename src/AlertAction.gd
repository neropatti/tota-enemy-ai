extends Node2D

onready var game_control_button = $GameControlButton
onready var action_name = $Label


func show_alert_action(button_key: String, label: String = "Take"):
	var animate_button = true
	game_control_button.show_button(button_key, animate_button)
	action_name.text = label
	self.visible = true


func hide_alert_action():
	game_control_button.hide_button()
	self.visible = false
