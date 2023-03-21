extends Timer

export(float) var wait_duration = 250


func _ready():
	self.wait_time = wait_duration
