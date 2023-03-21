extends Node2D

onready var anim_player = $AnimationPlayer
onready var exclamation_mark = $Bubble/ExclamationMark
onready var question_mark = $Bubble/QuestionMark
onready var sleep = $Bubble/Sleep
onready var timer = $Timer

const DURATION_TO_SHOW_ALERT: float = 1.0

var alert_types = null
var currently_playing_alert_type: String = ""


func _ready():
	self.visible = false
	alert_types = {"attention": exclamation_mark, "question": question_mark, "sleep": sleep}
	reset_alerts()
	timer.connect("timeout", self, "_on_shown_alert")


func reset_alerts():
	for a in alert_types.values():
		a.visible = false


func show_bubble(alert_type: String):
	if alert_type == currently_playing_alert_type:
		return
	currently_playing_alert_type = alert_type
	self.visible = true
	_show_alert(alert_type)
	anim_player.play("Show")
	yield(anim_player, "animation_finished")
	timer.start(DURATION_TO_SHOW_ALERT)


func _on_shown_alert():
	timer.stop()
	hide_bubble()


func hide_bubble():
	anim_player.play_backwards("Show")
	yield(anim_player, "animation_finished")
	self.visible = false
	currently_playing_alert_type = ""
	reset_alerts()


func _show_alert(alert_type):
	self.alert_types[alert_type].visible = true
