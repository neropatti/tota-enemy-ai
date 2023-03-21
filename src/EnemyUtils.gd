extends Node

const BISON_WEIGHT = 1
const BOAR_WEIGHT = 3
const MAMMOTH_WEIGHT = 5

# Excludes ['Rabbit']
var enemy_threats = ["Bison", "Boar", "Goat", "Wolf", "Bear", "Smilodon", "Mammoth"]


func get_enemy_count(y_sort: YSort) -> int:
	var enemy_count = 0
	var enemies_children = _get_enemies_children(y_sort)
	if enemies_children == null:
		return enemy_count
	for child in enemies_children:
		if child.is_dead():
			continue
		if _is_an_enemy_in_room(child):
			enemy_count += 1
	return enemy_count


func get_enemy_threat(y_sort: YSort) -> int:
	var enemy_threat = 0
	var enemies_children = _get_enemies_children(y_sort)
	if enemies_children == null:
		return enemy_threat
	for child in enemies_children:
		if child.is_dead():
			continue
		if _is_an_enemy_in_room(child):
			enemy_threat += _get_enemy_weighting(child.name)
	return enemy_threat


func get_threat_level(total_enemy_weighting) -> int:
	var threat_level = 0
	if total_enemy_weighting >= 5:
		threat_level = 100
	elif total_enemy_weighting >= 1:
		threat_level = 50

	return threat_level


func _get_enemies_children(y_sort: YSort):
	var enemies = y_sort.get_node_or_null("Enemies")
	if enemies == null:
		return null
	var enemies_children = enemies.get_children()
	return enemies_children


func _is_an_enemy_in_room(child: Node2D):
	var name = child.name
	var is_enemy_threat: bool = false
	for enemy in enemy_threats:
		if enemy in name:
			is_enemy_threat = true
			break
	return is_enemy_threat


func _get_enemy_weighting(name: String) -> int:
	var weighting = 0
	if "Bison" in name:
		weighting += BISON_WEIGHT
	elif "Boar" in name:
		weighting += BOAR_WEIGHT
	elif "Mammoth" in name:
		weighting += MAMMOTH_WEIGHT

	return weighting
