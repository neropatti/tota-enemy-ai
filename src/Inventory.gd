extends Control

onready var state_machine = $StateMachine
onready var controller = $Controller
onready var selected_slot = $SelectedSlot
onready var item_manager = $ItemManager
onready var model = $Model

var is_enabled = false


func _ready():
	controller.render_items(false)
	state_machine.start()
	selected_slot.visible = false


func add_new_item(item_id: String) -> String:
	return controller.add_new_item(item_id)


# @TODO test this function
func has_item(item_id: String) -> bool:
	return item_manager.has_item(item_id)


# @TODO test this function
func get_next_item_by_id(item_id: String) -> bool:
	return item_manager.get_next_item_by_id(item_id)


# @TODO test this function
func change_item(item_uuid: String, new_item_id: String) -> Dictionary:
	var new_item_added = item_manager.change_item(item_uuid, new_item_id)
	controller.render_items(true)
	return new_item_added


func replace_currently_selected_item(item: Dictionary):
	return controller.replace_currently_selected_item(item)


func add_weapon(item: Dictionary) -> void:
	controller.add_weapon(item)


func remove_existing_weapon() -> void:
	controller.remove_existing_weapon()


func get_weapon() -> Dictionary:
	return item_manager.get_weapon()


func clear_items():
	item_manager.clear_items()
	controller.render_items(true)


func age_items():
	item_manager.age_items()


func set_selected_storage_item(storage_item):
	model.current_selected_storage_item = storage_item


func set_selected_crafting_item(crafting_item):
	model.current_selected_crafting_item = crafting_item


func replace_item(external_item: Dictionary):
	controller.replace_currently_selected_item(external_item)


func increase_item_use_count(item_uuid: String, use_count: float) -> void:
	pass


func remove_item(item_uuid: String):
	controller.remove_item(item_uuid)


func item_discarded():
	controller.discarded_item()
	controller.set_current_focused_item_by_index(false)


func remove_focused_item():
	controller.remove_focused_item()


func remove_selected_item():
	controller.remove_selected_item()


func has_selected_item() -> bool:
	return model.current_selected_item_index != null


func open():
	state_machine.open()


func close():
	state_machine.close()


func focus():
	state_machine.focus()


func unfocus():
	state_machine.unfocus()


func hide():
	state_machine.hidden()


func get_controller():
	return controller


func get_model():
	return model
