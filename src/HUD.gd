extends Control

export(Resource) var runtime_data = runtime_data as RuntimeData
export(PoolStringArray) var items_in_inventory
export(PoolStringArray) var items_in_storage

onready var action_buttons = $ActionButtons
onready var stats = $Stats
onready var inventory = $Inventory
onready var item_details = $ItemDetails
onready var storage = $Storage
onready var crafting = $Crafting
onready var state_machine = $StateMachine
onready var controller = $Controller
onready var audio = $Audio

var return_to_state: String = ""


func _ready():
	_add_listeners()

	# start state machine
	state_machine.start()
	
	if items_in_inventory.size() > 0:
		__temp_add_items()


func _input(event):
	if event.is_action_released("reload-scene-r-key"):
		get_tree().reload_current_scene()


func _add_listeners():
	Events.connect("changed_screen", self, "_on_changed_screen")
	Events.connect("take_collectable_requested", self, "_on_take_collectable_requested")
	Events.connect("start_campfire_requested", self, "_on_start_campfire_requested")
	Events.connect("use_item_requested", self, "_on_use_item_requested")
	Events.connect("satchel_focused", self, "_on_satchel_focused")
	Events.connect("satchel_full", self, "_on_satchel_full")
	Events.connect("focused_item", self, "_on_focused_item")
	Events.connect("selected_item", self, "_on_selected_item")
	Events.connect("deselected_item", self, "_on_deselected_item")
	Events.connect("discard_item_requested", self, "_on_discard_item_requested")
	Events.connect("discard_item_success", self, "_on_discard_item_success")
	Events.connect("equip_item_requested", self, "_on_equip_item_requested")
	Events.connect("satchel_selected_item", self, "_on_satchel_selected_item")
	Events.connect("satchel_deselected_item", self, "_on_satchel_deselected_item")
	Events.connect("satchel_swapped_items", self, "_on_satchel_swapped_items")
	Events.connect("storage_swapped_items", self, "_on_storage_swapped_items")
	Events.connect("storage_selected_item", self, "_on_storage_selected_item")
	Events.connect("storage_deselected_item", self, "_on_storage_deselected_item")
	Events.connect("storage_add_items", self, "_on_storage_add_items")
	Events.connect("crafting_swapped_items", self, "_on_crafting_swapped_items")
	Events.connect("crafting_selected_item", self, "_on_crafting_selected_item")
	Events.connect("crafting_deselected_item", self, "_on_crafting_deselected_item")
	Events.connect("crafting_add_items", self, "_on_crafting_add_items")
	Events.connect("player_taken_damage", self, "_on_player_taken_damage")
	Events.connect("player_health_restored", self, "_on_player_health_restored")
	Events.connect("player_used_stamina", self, "_on_player_used_stamina")
	Events.connect("moved_satchel_item_to_storage", self, "_on_moved_satchel_item_to_storage")
	Events.connect("moved_storage_item_to_satchel", self, "_on_moved_storage_item_to_satchel")
	Events.connect("moved_satchel_item_to_crafting", self, "_on_moved_satchel_item_to_crafting")
	Events.connect("moved_crafting_item_to_satchel", self, "_on_moved_crafting_item_to_satchel")
	Events.connect("started_dialogue", self, "_on_started_dialogue")
	Events.connect("finished_dialogue", self, "_on_finished_dialogue")
	Events.connect("location_announcement_requested", self, "_on_location_announcement_requested")
	Events.connect("quest_announcement_requested", self, "_on_quest_announcement_requested")
	Events.connect("opened_settings", self, "_on_opened_settings")
	Events.connect("finished_location_announcement", self, "_on_finished_location_announcement")
	Events.connect("finished_quest_announcement", self, "_on_finished_quest_announcement")
	Events.connect("entered_pond_replenish_requested", self, "_on_entered_pond_replenish_requested")
	Events.connect("fill_waterskin_requested", self, "_on_fill_waterskin_requested")
	Events.connect("player_fell_down_hole", self, "_on_player_fell_down_hole")
	Events.connect("moving_to_next_day", self, "_on_moving_to_next_day")


func _on_changed_screen(_from, _to):
	state_machine._change_state("NoHUD")


func __temp_add_items():
	inventory.add_new_item(Items.SPEAR)
	inventory.add_new_item(Items.NUTSHAZELNUTS)
	storage.add_items(
		[
			#		"Band",
			#		"BerriesBittersweet",
			#		"BerriesBlackberries",
			#		"BerriesDeadlyNightshade",
			#		"BerriesIvy",
			#		"BerriesRosehips",
			#		"BerriesStrawberries",
			#		"BirdFeatherDark",
			#		"BirdFeatherLight",
			#		"BirdFeatherMagpie",
			#		"Clay",
			#		"FeatherDark",
			#		"FeatherLight",
			#		"FeatherMagpie",
			#		"Firewood",
			#		"FishSalmonCooked",
			#		"FishSalmonRaw",
			#		"FishTroutCooked",
			#		"FishTroutRaw",
			#		"Flint",
			#		"FlowerChamomile",
			#		"FlowerDaisy",
			#		"FlowerHibiscus",
			#		"FlowerLavender",
			#		"FlowerLily",
			#		"GingerRoot",
			#		"HerbAloeVera",
			#		"HerbBlueFenugreek",
			#		"HerbChicory",
			#		"HerbGoosefoot",
			#		"HerbHorseradish",
			#		"HerbMugwart",
			#		"HerbNettles",
			#		"InsectAnt",
			#		"InsectBeetle",
			#		"MeatBisonLoinCooked",
			#		"MeatBisonLoinRaw",
			#		"MeatBoarLoinCooked",
			#		"MeatBoarLoinRaw",
			#		"MeatIbexLoinCooked",
			#		"MeatIbexLoinRaw",
			#		"MeatMammothLoinCooked",
			#		"MeatMammothLoinRaw",
			#		"MeatRabbitLoinCooked",
			#		"MeatRabbitLoinRaw",
			#		"MeatRhinoLoinCooked",
			#		"MeatRhinoLoinRaw",
			#		"MeatVenisonLoinCooked",
			#		"MeatVenisonLoinRaw",
			#		"Moss",
					"NutsAcorns",
			#		"NutsHazelnuts",
			#		"Pear",
			#		"PotatoCooked",
			#		"PotatoRaw",
			#		"RabbitLoinCooked",
			#		"RabbitLoinRaw",
			#		"Rock",
			#		"RockAxeHead",
			#		"RockSpearTip",
			#		"Seeds",
			#		"Sinew",
			#		"SmallAxe",
			#		"SmilodonTooth",
			#		"Spear",
			#		"Stick",
			#		"TreeResin",
			# "VenisonLoinRaw",
#			"WaterskinEmpty",
			#		"WaterskinFull"
		]
	)


func get_controller():
	return controller

func get_audio():
	return audio


# When player moves to item
func _on_focused_item(item):
	if item != null:
		item_details.set_item(item)
		action_buttons.set_item_focused(item)
	else:
		item_details.set_item(null)
		action_buttons.set_item_focused(null)


# When player selects the item in focus
func _on_selected_item(item):
	action_buttons.set_item_selected(item)
	audio.play_select_fx()


# When player deselects the item in focus
func _on_deselected_item(item):
	action_buttons.set_item_deselected(item)
	item_details.set_item(item)
	audio.play_back_fx()


func _on_equip_item_requested(item):
	inventory.remove_item(item.uuid)
	var existing_weapon = inventory.get_weapon()
	if existing_weapon:
		inventory.replace_currently_selected_item(existing_weapon)
		inventory.remove_existing_weapon()
		item_details.set_item(existing_weapon)
		action_buttons.set_item_focused(existing_weapon)
	inventory.add_weapon(item)
	Events.emit_signal("equip_item_success", item)
	audio.play_equip_fx()


func _on_crafting_selected_item(crafting_item, slot_position: Vector2):
	if state_machine.has_current_state("CraftingFocus"):
		if crafting_item == null:
			print("selecting crafting item: null")
			return
		print("selecting crafting item: " + crafting_item.uuid)
		inventory.set_selected_crafting_item(crafting_item)


# fired when storage item is deselected/dehighlighted
func _on_crafting_deselected_item():
	if state_machine.has_current_state("CraftingFocus"):
		inventory.set_selected_crafting_item(null)


# When storage item is selected/highlighted
func _on_storage_selected_item(storage_item, slot_position: Vector2):
	if state_machine.has_current_state("StorageFocus"):
		if storage_item == null:
			print("selecting storage item: null")
			return
		print("selecting storage item: " + storage_item.uuid)
		inventory.set_selected_storage_item(storage_item)


# fired when storage item is deselected/dehighlighted
func _on_storage_deselected_item():
	if state_machine.has_current_state("StorageFocus"):
		inventory.set_selected_storage_item(null)


# fired when satchel item is selected/highlighted
func _on_satchel_selected_item(satchel_item):
	if state_machine.has_current_state("InventoryFocusStorage"):
		if satchel_item == null:
			print("selecting satchel item: null")
			return
		print("selecting satchel item: " + satchel_item.uuid)
		storage.set_selected_satchel_item(satchel_item)
	elif state_machine.has_current_state("InventoryFocusCrafting"):
		if satchel_item == null:
			print("selecting satchel item: null")
			return
		print("selecting satchel item: " + satchel_item.uuid)
		crafting.set_selected_satchel_item(satchel_item)


# fired when satchel item is deselected/dehighlighted
func _on_satchel_deselected_item():
	if state_machine.has_current_state("InventoryFocusStorage"):
		storage.set_selected_satchel_item(null)
	elif state_machine.has_current_state("InventoryFocusCrafting"):
		crafting.set_selected_satchel_item(null)


func _on_satchel_swapped_items(item_a, _item_b):
	# item_a is now in current focused slot
	action_buttons.set_item_deselected(item_a)
	audio.play_place_fx()


func _on_storage_swapped_items(item_a, _item_b):
	# item_a is now in current focused slot
	action_buttons.set_item_deselected(item_a)
	audio.play_place_fx()


func _on_crafting_swapped_items(item_a, _item_b):
	# item_a is now in current focused slot
	action_buttons.set_item_deselected(item_a)
	audio.play_place_fx()


func _on_moved_satchel_item_to_storage(item_from_storage):
	if state_machine.has_current_state("StorageFocus"):
		if item_from_storage != null and item_from_storage.id:
			audio.play_place_fx()
			inventory.replace_item(item_from_storage)
		elif inventory.has_selected_item():
			inventory.remove_selected_item()
			audio.play_place_fx()
		else:
			inventory.remove_focused_item()
			audio.play_discard_fx()


func _on_moved_storage_item_to_satchel(item_from_satchel):
	if state_machine.has_current_state("InventoryFocusStorage"):
		if item_from_satchel != null:
			audio.play_place_fx()
			storage.replace_selected_item(item_from_satchel)
		else:
			audio.play_place_fx()
			storage.remove_selected_item()


func _on_moved_crafting_item_to_satchel(item_from_satchel):
	if state_machine.has_current_state("InventoryFocusCrafting"):
		if item_from_satchel != null:
			crafting.replace_selected_item(item_from_satchel)
		else:
			crafting.remove_selected_item()


func _on_moved_satchel_item_to_crafting(item_from_crafting):
	if state_machine.has_current_state("CraftingFocus"):
		if item_from_crafting != null and item_from_crafting.id:
			audio.play_place_fx()
			inventory.replace_item(item_from_crafting)
		elif inventory.has_selected_item():
			audio.play_place_fx()
			inventory.remove_selected_item()
		else:
			inventory.remove_focused_item()


func _on_use_item_requested(item: Dictionary):
	if not item.is_usable or item.usage_left == 0:
		audio.play_reject_fx()
		return

	var stamina_empty_before = stats.stamina_has_depleted()

	var did_update_stats = stats.apply_item_to_stats(item.id)
	if not did_update_stats:
		Events.emit_signal("used_item_failed", item)
		return
	else:
		Events.emit_signal("used_item_succeeded", item)

	if stamina_empty_before && stats.stamina_not_empty():
		Events.emit_signal("player_stamina_restored")

	item.usage_left = clamp(item.usage_left - 1, 0, 100)

	controller.play_use_sound(item)

	if item.usage_left > 0:
		item_details.set_item(item)
		action_buttons.set_item_focused(item)
		return

	if item.is_discardable:
		audio.play_discard_fx()
		inventory.remove_item(item.uuid)

		action_buttons.set_item_focused(null)
		return

	if item.state_after_use != null:
		var new_item = inventory.change_item(item.uuid, item.state_after_use)
		item_details.set_item(new_item)
		action_buttons.set_item_focused(new_item)


func _on_item_action_combine(item_id: String):
	pass


func _on_discard_item_requested(item):
	audio.play_discard_fx()
	inventory.remove_item(item.uuid)


func _on_discard_item_success(_item_uuid: String):
	inventory.item_discarded()
	item_details.set_item(null)
	action_buttons.set_item_discarded()


func _on_player_taken_damage(damage_taken):
	var animate = true
	stats.health.apply(-damage_taken, animate)
	if stats.health_has_depleted():
		Events.emit_signal("player_killed")


func _on_player_health_restored(health_to_restore: float = 500.0) -> void:
	var animate = true
	stats.health.apply(health_to_restore, animate)


func _on_player_used_stamina(stamina_taken):
	var animate = true
	stats.stamina.apply(-stamina_taken, animate)
	if stats.stamina_has_depleted():
		Events.emit_signal("player_stamina_empty")


func _on_satchel_full():
	audio.play_reject_2_fx()


func _on_satchel_focused():
	pass


func _on_take_collectable_requested(item_id: String):
	inventory.add_new_item(item_id)


func _on_start_campfire_requested():
	# Can only start fire if firewood is in inventory
	var item = inventory.get_next_item_by_id("Firewood")
	if item != null:
		inventory.remove_item(item.uuid)
		Events.emit_signal("start_campfire_success")


func _on_started_dialogue(conversation_id: String) -> void:
	return_to_state = state_machine.current_state.name
	state_machine._change_state("DialogueFocus", {"conversation_id": conversation_id})


func _on_location_announcement_requested(announcement_id: String, play_sound: bool = true) -> void:
	return_to_state = state_machine.current_state.name
	state_machine._change_state(
		"LocationAnnouncementFocus", {"announcement_id": announcement_id, "play_sound": play_sound}
	)


func _on_quest_announcement_requested(announcement_id: String, play_sound: bool = true) -> void:
	return_to_state = ""
	state_machine._change_state(
		"QuestAnnouncementFocus", {"announcement_id": announcement_id, "play_sound": play_sound}
	)


func _on_opened_settings() -> void:
	state_machine._change_state("SettingsFocus")


func _on_player_fell_down_hole(damage_taken) -> void:
	stats.health.apply(-damage_taken, true)
	if stats.health_has_depleted():
		Events.emit_signal("player_killed")


func _on_moving_to_next_day() -> void:
	inventory.age_items()
	storage.age_items()


func _on_finished_dialogue():
	_return_to_original_state()


func _on_finished_location_announcement():
	_return_to_original_state()


func _on_finished_quest_announcement():
	state_machine._change_state("ShowHUD")


# Each day player is entitled to replenish stats 3 times by entering pond
func _on_entered_pond_replenish_requested():
	if runtime_data.pond_replenish_count >= 3:
		Events.emit_signal("entered_pond_replenish_failed")
		return
	Events.emit_signal("entered_pond_replenish_success")
	stats.replenish_health(100)
	stats.replenish_stamina(100)
	runtime_data.pond_replenish_count += 1


func _on_fill_waterskin_requested():
	var waterskin_empty = inventory.get_next_item_by_id("WaterskinEmpty")
	if waterskin_empty != null:
		Events.emit_signal("fill_waterskin_succeeded")
		return inventory.change_item(waterskin_empty.uuid, "WaterskinFull")
	else:
		var waterskin_full = inventory.get_next_item_by_id("WaterskinFull")
		if waterskin_full == null:
			return Events.emit_signal("fill_waterskin_failed")
		Events.emit_signal("fill_waterskin_succeeded")
		inventory.increase_item_use_count(waterskin_full.uuid, 3)


func _return_to_original_state():
	if return_to_state == "":
		return
	state_machine._change_state(return_to_state)


func _on_storage_add_items(items):
	storage.add_items(items)


func _on_crafting_add_items(items):
	crafting.add_items(items)
