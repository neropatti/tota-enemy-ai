extends Area2D

var threat = null


func can_see_threat():
	return threat != null


func _on_ThreatDetectionZone_body_entered(body):
	if body && body.get_name() == "Player":
		threat = body
