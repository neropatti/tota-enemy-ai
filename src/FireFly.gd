extends Node2D

onready var anim_player = $AnimationPlayer
onready var light = $Light2D
onready var tween = $Tween

const ENERGY_VISIBLE: float = 0.6
const ENERGY_INVISIBLE: float = 0.0
const FADE_DURATION: float = 1.0

var stored_seconds: float = 0.0


func _ready():
	set_process_input(false)
	set_physics_process(false)
	_play()


func fade_in():
	_play()
	tween.stop(light)
	tween.interpolate_property(
		light, "energy", ENERGY_INVISIBLE, ENERGY_VISIBLE, FADE_DURATION, Tween.TRANS_EXPO
	)
	tween.start()


func fade_out():
	anim_player.stop()
	tween.stop(light)
	tween.interpolate_property(
		light, "energy", ENERGY_VISIBLE, ENERGY_INVISIBLE, FADE_DURATION, Tween.TRANS_EXPO
	)
	tween.start()


func seek(seconds: float):
	stored_seconds = seconds
	anim_player.seek(stored_seconds)


func _play():
	anim_player.stop()
	if stored_seconds != 0.0:
		anim_player.seek(stored_seconds)
	anim_player.play("float")
