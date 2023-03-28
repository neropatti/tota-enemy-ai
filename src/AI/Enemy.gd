extends KinematicBody2D

enum MOOD_TYPES { NONE, RESERVED, DEFENSIVE, ANGRY, CURIOUS, PREDATORY, DETERMINED }

enum MOVE_TYPE { WALK, RUN }

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1
const DEFAULT_FOV_LOOK_TO = Vector2(45, 0)

signal target_reached

export(int, "None", "Reserved", "Defensive", "Angry", "Curious", "Predatory", "Determined") var mood = MOOD_TYPES.RESERVED
export(int) var target_distance_to_stop_walking = 3
export(int) var target_distance_to_stop_charging = 30
export(float) var wandering_distance := 32.0
export(float) var wait_move_duration := 2.5
export(int) var wait_move_multiplier := 1
export(float) var enemy_walk_speed := 100.0
export(float) var enemy_run_speed := 300.0
export(float) var enemy_sound_detection_zone := 250.0

onready var audio = $Audio
onready var hit_box = $Areas/HitBox
onready var hurt_box = $Areas/HurtBox
onready var predatory_zone: Area2D = $Areas/PredatoryZone
onready var stats_value_change = $StatValueChange
onready var hurt_cooldown = $HurtCooldown
onready var state_machine = $StateMachine
onready var controller = $Controller
onready var animation_tree = $AnimationTree
onready var fov = $FieldOfView
onready var wait_timer: Timer = $"%WaitTimer"
onready var walk_expired_timer: Timer = $"%WalkExpiredTimer"
onready var player_left_timer: Timer = $"%PlayerLeftTimer"
onready var navigation_agent = $NavigationAgent2D
onready var navigation_obstacle = $NavigationObstacle2D
onready var path_line = $CanvasLayer/PathLine
onready var vision: RayCast2D = $Vision
onready var player_sound_detection_zone = $"%PlayerSoundDetectionZone"

var player = null
var speed: float = enemy_walk_speed
var total_distance_to_target = null
var original_allocated_position
var move_type = MOVE_TYPE.WALK
var velocity: Vector2 = Vector2.ZERO
var last_position_player_spotted: Vector2
var last_position_player_predatory: Vector2
var longest_distance_point = global_position

var player_in_predatory_zone = null


func _init():
	#TODO - set radius for sound detection
	enemy_sound_detection_zone


func _ready():
	animation_tree.active = true
	state_machine.start()
#	audio.play_idle()
	_set_fov_direction()
	_add_listeners()
	_init_areas()
	
	
func _exit_tree():
	_remove_listeners()


func _init_areas() -> void:
	hit_box.enable()
	hurt_box.enable()
	if hit_box:
		hit_box.connect("area_entered", self, "_on_hit_box_area_entered")
	if hurt_box:
		hurt_box.connect("area_entered", self, "_on_hurt_box_area_entered")


func _set_fov_direction():
	fov.look_at(self.position - DEFAULT_FOV_LOOK_TO)


func _add_listeners() -> void:
	navigation_agent.connect("path_changed", self, "_on_path_changed")
	navigation_agent.connect("velocity_computed", self, "_on_velocity_computed")
	fov.connect("target_enter", self, "_on_target_enter")
	fov.connect("target_exit", self, "_on_target_exit")
	
	predatory_zone.connect("body_entered", self, "_on_target_predatory_enter")
	predatory_zone.connect("body_exited", self, "_on_target_predatory_exited")

func _remove_listeners() -> void:
	navigation_agent.disconnect("path_changed", self, "_on_path_changed")
	navigation_agent.disconnect("velocity_computed", self, "_on_velocity_computed")
	fov.disconnect("target_enter", self, "_on_target_enter")
	fov.disconnect("target_exit", self, "_on_target_exit")

func get_controller():
	return controller


func idle() -> void:
	state_machine._change_state("Idle")


func walk() -> void:
	speed = enemy_walk_speed
	set_move_type_walking()
	state_machine._change_state("Walk")


func graze() -> void:
	state_machine._change_state("Graze")


func spotted_player() -> void:
	state_machine._change_state("SpottedPlayer")


func pre_charge() -> void:
	state_machine._change_state("PreCharge")


func charge() -> void:
	speed = enemy_run_speed
	set_move_type_run()
	state_machine._change_state("Charge")


func attack() -> void:
	state_machine._change_state("Attack")


func die() -> void:
	state_machine._change_state("Die")


func hurt() -> void:
	state_machine._change_state("Hurt")


func is_attacking() -> bool:
	return state_machine.is_attacking()


func is_pre_charging():
	return state_machine.is_pre_charging()


func is_charging():
	return state_machine.is_charging()


func is_grazing() -> bool:
	return state_machine.is_grazing()


func is_walking() -> bool:
	return state_machine.is_walking()


func is_running() -> bool:
	return state_machine.is_running()


func is_idle() -> bool:
	return state_machine.is_idle()


func is_mood_reserved() -> bool:
	return mood == MOOD_TYPES.RESERVED


func is_mood_defensive() -> bool:
	return mood == MOOD_TYPES.DEFENSIVE


func is_mood_angry() -> bool:
	return mood == MOOD_TYPES.ANGRY


func is_mood_curious() -> bool:
	return mood == MOOD_TYPES.CURIOUS


func is_mood_predatory() -> bool:
	return mood == MOOD_TYPES.PREDATORY


func is_mood_determined() -> bool:
	return mood == MOOD_TYPES.DETERMINED


func set_mood_reserved() -> void:
	mood = MOOD_TYPES.RESERVED


func set_mood_defensive() -> void:
	mood = MOOD_TYPES.DEFENSIVE


func set_mood_angry() -> void:
	mood = MOOD_TYPES.ANGRY


func set_mood_curious() -> void:
	mood = MOOD_TYPES.CURIOUS


func set_mood_predatory() -> void:
	mood = MOOD_TYPES.PREDATORY


func set_mood_determined() -> void:
	mood = MOOD_TYPES.DETERMINED


func set_move_type_walking() -> void:
	move_type = MOVE_TYPE.WALK


func set_move_type_run() -> void:
	move_type = MOVE_TYPE.RUN


func set_random_walk_to_position() -> Vector2:
	return find_longest_distance_to_walk_to()


#	var offset := Vector2(
#		rand_range(-wandering_distance, wandering_distance),
#		rand_range(-wandering_distance, wandering_distance)
#	)
#	var pos = self.global_position + offset
#
#	$CanvasLayer/ColorRect.set_global_position(pos)
#	print('Enemy - set pos: ' + str(pos))
#	return pos

#func draw_circle_arc(center, radius, angle_from, angle_to, color):
#	var nb_points = 12
#	var points_arc = PoolVector2Array()
#
#	for i in range(nb_points + 1):
#		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#	for index_point in range(nb_points):
#		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 4)
#
#func _draw():
#	var center = Vector2(400, 400)
#	var radius = 300
#	var angle_from = 0
#	var angle_to = 360
#	var color = Color(1.0, 0.0, 0.0)
#	draw_circle_arc(center, radius, angle_from, angle_to, color)


func find_longest_distance_to_walk_to() -> Vector2:
	var space_state = get_world_2d().direct_space_state
	var center = self.global_position
	var _longest_distance_point = center
	var radius = wandering_distance
	var angle_from = 0
	var angle_to = 360
	var nb_points = 12
	var walk_to_pos
	var fallback_random_direction = int(rand_range(0.0, nb_points))

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		var next_cast_pos = center + Vector2(cos(angle_point), sin(angle_point)) * radius
		var next_distance
		var current_distance
		var result = space_state.intersect_ray(center, next_cast_pos, [self], collision_mask)

		print("Checking around: " + str(next_cast_pos))
		
		if i == fallback_random_direction and not result:
			walk_to_pos = (
				center
				+ Vector2(cos(angle_point), sin(angle_point)) * radius
			)

		elif result and result.collider:
			var collision_point = self.global_position + result.collider.position
			current_distance = center.distance_to(_longest_distance_point)
			next_distance = center.distance_to(collision_point)

			print("collision_point: " + str(collision_point))
			print("current_distance: " + str(current_distance))
			print("next_distance: " + str(next_distance))

			if next_distance > current_distance:
				walk_to_pos = (
					center
					+ Vector2(cos(angle_point), sin(angle_point)) * radius
				)
				_longest_distance_point = collision_point
				print("---- longest_distance_point set to: " + str(_longest_distance_point))
			

	vision.cast_to = _longest_distance_point

	return walk_to_pos


func _process(delta):
	$CanvasLayer_DEBUG/ColorRect.set_global_position(navigation_agent.get_target_location())


func set_facing_direction(position_moving_towards: Vector2):
	var direction
	var enemy_x_pos = position.x
	var target_x_pos = position_moving_towards.x
	if enemy_x_pos > target_x_pos:
		direction = DIRECTION_LEFT
	else:
		direction = DIRECTION_RIGHT
	fov.look_at(position_moving_towards)
	state_machine.update_look_direction(direction)


func set_target_location(location: Vector2):
	navigation_agent.set_target_location(location)
	total_distance_to_target = navigation_agent.distance_to_target()


func get_target_location() -> Vector2:
	return navigation_agent.get_target_location()


func move_towards_target_location():
	if navigation_agent.is_navigation_finished():
		set_facing_direction(navigation_agent.get_target_location())
		return
	var next_location_point: Vector2 = navigation_agent.get_next_location()
	var move_direction = global_position.direction_to(next_location_point)

	if move_type == MOVE_TYPE.WALK:
		if not is_walking():
			walk()
	else:
		if not is_running():
			charge()

	velocity = move_direction * speed
	navigation_agent.set_velocity(velocity)
	set_facing_direction(next_location_point)


func arrived_at_target_location() -> bool:
	var is_finished: bool = navigation_agent.is_navigation_finished()
	return is_finished


func in_danger_area() -> bool:
	return not fov.in_danger_area.empty()


func in_warn_area() -> bool:
	return not fov.in_warn_area.empty()


func _on_path_changed():
	if not path_line:
		return
	path_line.width = 10
	path_line.points = navigation_agent.get_nav_path()


func _on_velocity_computed(safe_velocity: Vector2):
	print("Enemy - velocity: " + str(safe_velocity))
	velocity = move_and_slide(safe_velocity)


#	if not arrived_at_target_location():


func _on_target_enter(obj) -> void:
	player = obj


func _on_target_exit(obj) -> void:
	last_position_player_spotted = player.global_position
	player = null


func _on_hurt_box_area_entered(area: Area2D):
	assert(area.damage_inflicted)

	var actual_damage = rand_range(area.damage_inflicted / 3, area.damage_inflicted)

	controller.take_damage(actual_damage)
	stats_value_change.lost_health(actual_damage)

#	if controller.has_health():
#		trigger_hurt()
#	else:
#		trigger_death()


func _on_target_predatory_enter(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		player_in_predatory_zone = body


func _on_target_predatory_exited(body) -> void:
	if body.is_in_group("player") and body == player_in_predatory_zone:
		player_in_predatory_zone = null
		last_position_player_predatory = body.global_position







