extends Node

export(NodePath) onready var model = get_node(model) as Node
export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var state_machine = get_node(state_machine) as Node
export(NodePath) onready var hurt_box = get_node(hurt_box) as Area2D
export(NodePath) onready var hit_box = get_node(hit_box) as Area2D
export(NodePath) onready var player_detection_zone = get_node(player_detection_zone) as Area2D
export(NodePath) onready var dead_collect_zone = get_node(dead_collect_zone) as Area2D
export(NodePath) onready var anim_player = get_node(anim_player) as AnimationPlayer
export(NodePath) onready var anim_tree = get_node(anim_tree) as AnimationTree
export(NodePath) onready var health_bar = get_node(health_bar) as ProgressBar
export(NodePath) onready var timer = get_node(timer) as Timer
export(NodePath) onready var detected_player_timer = get_node(detected_player_timer) as Timer
export(NodePath) onready var cooldown_timer = get_node(cooldown_timer) as Timer
export(NodePath) onready var alert_bubble = get_node(alert_bubble)


func take_damage(damage_inflicted: int):
	var anim_state = get_anim_state()
	show_health_bar()
	health_bar.deduct(damage_inflicted)


func get_anim_state() -> AnimationNodeStateMachinePlayback:
	var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
	return anim_state


func get_target_position():
	var target: Node2D = owner.target
	if target == null:
		return null
	return target.global_position


func has_detected_player_recently() -> bool:
	var time_left = detected_player_timer.time_left
	return time_left > 0


func set_initial_player_detection_zone() -> void:
	update_player_detection_radius(
		false,
		rand_range(
			model.min_player_detection_radius, round(model.min_player_detection_radius * 1.5)
		)
	)


func increase_player_detection_zone() -> void:
	update_player_detection_radius(true)


func update_player_detection_radius(should_increment = false, radius = null):
	var collision: CollisionShape2D = player_detection_zone.get_node("CollisionShape2D")
	if radius == null:
		radius = collision.shape.radius
	if should_increment:
		radius += model.player_detection_radius_increase
	var shape = CircleShape2D.new()
	shape.radius = clamp(
		radius, model.min_player_detection_radius, model.max_player_detection_radius
	)
	collision.set_deferred("shape", shape)


func show_alert_heard_noise():
	alert_bubble.show_bubble("question")
	start_detection_cooldown()


func show_alert_found_player():
	alert_bubble.show_bubble("attention")
	start_detection_cooldown()


func start_detection_cooldown():
	detected_player_timer.stop()
	detected_player_timer.start(10)
	yield(detected_player_timer, "timeout")
	detected_player_timer.stop()


func allow_meat_collection():
	dead_collect_zone.visible = true


func dispose_enemy():
	owner.queue_free()


func has_health() -> bool:
	return health_bar.has_health()


func show_health_bar():
	health_bar.visible = true


func get_animation_tree():
	return anim_tree


func get_path_to_target():
	var target_position = get_target_position()
	var navigation_2d: Navigation2D = owner.navigation_2d
	if not navigation_2d:
		return PoolVector2Array()
	return navigation_2d.get_simple_path(owner.global_position, target_position)


func disable_collisions():
	hurt_box.disable()
	hit_box.disable()
	player_detection_zone.disable()
