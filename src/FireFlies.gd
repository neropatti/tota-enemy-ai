extends YSort

onready var anim_player = $AnimationPlayer
onready var pos_2d = $Position2D
onready var tween = $Tween

const FADE_DURATION = 1.0
const HIDDEN = Color(1, 1, 1, 0)
const VISIBLE = Color(1, 1, 1, 1)
const ANIM_GAP: float = 4.0

var fireflies_showing: bool = false


func _ready():
	set_physics_process(false)
	set_process_input(false)
	set_process(false)
	pos_2d.modulate = HIDDEN
	var seek = 0.0
	for c in pos_2d.get_children():
		c.seek(seek)
		seek += ANIM_GAP


func is_showing() -> bool:
	return fireflies_showing


func fade_in():
	if fireflies_showing:
		return
	self.visible = true
	tween.stop_all()
	fireflies_showing = true
	pos_2d.modulate = HIDDEN
	_play()
	tween.interpolate_property(pos_2d, "modulate", HIDDEN, VISIBLE, FADE_DURATION, Tween.TRANS_EXPO)
	for f in pos_2d.get_children():
		f.fade_in()
	tween.start()
	yield(tween, "tween_completed")
	tween.stop_all()


func fade_out():
	if not fireflies_showing:
		return
	tween.stop_all()
	fireflies_showing = false
	pos_2d.modulate = VISIBLE
	tween.interpolate_property(pos_2d, "modulate", VISIBLE, HIDDEN, FADE_DURATION, Tween.TRANS_EXPO)
	for f in pos_2d.get_children():
		f.fade_out()
	tween.start()
	yield(tween, "tween_completed")
	anim_player.stop()
	tween.stop_all()
	self.visible = false


func _play():
	anim_player.play("rotate")
