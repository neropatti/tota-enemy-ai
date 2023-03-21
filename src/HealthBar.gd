extends ProgressBar

onready var timer := $Timer
onready var anim_player := $AnimationPlayer

export(float) var HEALTH = 1000

var time_to_wait_before_hiding: int = 3


func _ready():
	self.max_value = HEALTH
	self.value = HEALTH
	self.visible = false
	timer.connect("timeout", self, "_on_timeout")


func deduct(damage: float):
	timer.stop()
	self.value -= damage
	self.visible = true
	anim_player.play("ShowBar")
	timer.start(time_to_wait_before_hiding)


func has_health():
	return self.value > 0


func _on_timeout():
	timer.stop()
	anim_player.play("HideBar")
