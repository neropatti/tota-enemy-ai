extends Control

onready var spritesheet: Sprite = $Sprite
onready var timer: Timer = $Timer
onready var label_node: Label = $Label

const SPRITE_SIZE = 16
const ANIMATE_DELAY_S = 0.5
const DISABLED_COLOR = Color(1, 1, 1, 0.5)
const ENABLED_COLOR = Color(1, 1, 1, 1)

export(int) var button_size = SPRITE_SIZE


func offset_pos(multipler: int) -> int:
	return SPRITE_SIZE * multipler


var key_to_button_sprite_offset_mapping = {
	"move_up": Vector2(offset_pos(2), offset_pos(3)),
	"move_up_pressed": Vector2(offset_pos(6), offset_pos(3)),
	"move_right": Vector2(offset_pos(2), offset_pos(3)),
	"move_right_pressed": Vector2(offset_pos(3), offset_pos(3)),
	"move_down": Vector2(offset_pos(2), offset_pos(3)),
	"move_down_pressed": Vector2(offset_pos(4), offset_pos(3)),
	"move_left": Vector2(offset_pos(2), offset_pos(3)),
	"move_left_pressed": Vector2(offset_pos(5), offset_pos(3)),
	"action": Vector2(0, 0),
	"action_pressed": Vector2(offset_pos(1), 0),
	"attack": Vector2(0, offset_pos(1)),
	"attack_pressed": Vector2(offset_pos(1), offset_pos(1)),
	"sit": Vector2(0, offset_pos(2)),
	"sit_pressed": Vector2(offset_pos(1), offset_pos(2)),
	"roll": Vector2(0, offset_pos(3)),
	"roll_pressed": Vector2(offset_pos(1), offset_pos(3)),
	"toggle_stat_focus": Vector2(offset_pos(9), 0),
	"toggle_stat_focus_pressed": Vector2(offset_pos(8), 0),
	"toggle_weapon": Vector2(offset_pos(9), offset_pos(1)),
	"toggle_weapon_pressed": Vector2(offset_pos(8), offset_pos(1)),
	"toggle_stats_show": Vector2(offset_pos(9), offset_pos(2)),
	"toggle_stats_show_pressed": Vector2(offset_pos(8), offset_pos(2)),
	"toggle_satchel": Vector2(offset_pos(9), offset_pos(3)),
	"toggle_satchel_pressed": Vector2(offset_pos(8), offset_pos(3)),
	"toggle_menu": Vector2(offset_pos(6), 0),
	"toggle_menu_pressed": Vector2(offset_pos(9), 0),
	"toggle_map": Vector2(offset_pos(3), 0),
	"toggle_map_pressed": Vector2(offset_pos(3), 0)
}
var current_key = "action"
var current_key_pressed = current_key + "_pressed"
var current_offset = key_to_button_sprite_offset_mapping[current_key]
var current_offset_pressed = current_offset + Vector2(SPRITE_SIZE, 0)
var button_states = [current_key, current_key_pressed]


func _ready():
	spritesheet.region_enabled = true
	label_node.visible = false
	self.rect_min_size = Vector2(button_size, button_size)
	self.visible = false


func show_button(key: String, is_animated: bool = true, label: String = ""):
	current_key = key
	current_key_pressed = key + "_pressed"
	button_states = [current_key, current_key_pressed]
	current_offset = key_to_button_sprite_offset_mapping[current_key]
	current_offset_pressed = key_to_button_sprite_offset_mapping[current_key_pressed]
	spritesheet.region_rect = Rect2(current_offset, Vector2(SPRITE_SIZE, SPRITE_SIZE))
	self.visible = true
	if is_animated:
		_animate_button()
	if label != "":
		_show_label(label)
	self.rect_min_size = rect_size


func _show_label(label: String):
	label_node.text = label
	label_node.visible = true
	calculate_label_width()


func calculate_label_width():
	var label: String = label_node.text
	var font_size = label_node.get_font("font").get_string_size(label)
	label_node.rect_min_size.x = font_size.x + button_size
	label_node.rect_size.x = label_node.rect_min_size.x
	self.rect_min_size.x = button_size + label_node.rect_size.x
	self.rect_size.x = self.rect_min_size.x


func set_pressed_state():
	set_sprite(current_key_pressed)


func set_released_state():
	set_sprite(current_key)


func hide_button():
	self.visible = false
	timer.stop()


func enable(is_animated: bool = false):
	if is_animated and timer.is_stopped():
		timer.start(ANIMATE_DELAY_S)
	spritesheet.self_modulate = ENABLED_COLOR
	label_node.self_modulate = ENABLED_COLOR


func disable():
	if !timer.is_stopped():
		timer.stop()
	set_sprite(current_key)
	spritesheet.self_modulate = DISABLED_COLOR
	label_node.self_modulate = DISABLED_COLOR


func _animate_button():
	if !timer.is_stopped():
		timer.stop()
	button_states = [current_key, current_key_pressed]
	timer.start(ANIMATE_DELAY_S)


func _on_Timer_timeout():
	button_states.invert()
	var sprite_key = button_states[0]
	set_sprite(sprite_key)


func set_sprite(key: String):
	spritesheet.region_rect = Rect2(
		key_to_button_sprite_offset_mapping[key], Vector2(SPRITE_SIZE, SPRITE_SIZE)
	)
