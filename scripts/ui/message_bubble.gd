extends MarginContainer

# A reusable WhatsApp message bubble

@onready var bg: PanelContainer = $Panel
@onready var label: RichTextLabel = $Panel/MarginContainer/VBox/Label
@onready var time_label: Label = $Panel/MarginContainer/VBox/TimeLabel

const COLOR_ME := Color("E1FFC7") # WhatsApp light green
const COLOR_OTHER := Color("FFFFFF") # White

var _is_me: bool = false

func setup(text: String, is_me: bool, time_str: String = "12:00") -> void:
	_is_me = is_me
	label.text = text
	time_label.text = time_str
	
	# Set a fixed width of ~60% of the mockup (454 * 0.6 ≈ 270)
	var bubble_width = 270
	custom_minimum_size.x = bubble_width
	bg.custom_minimum_size.x = bubble_width
	label.custom_minimum_size.x = bubble_width - 30 # Account for margins
	
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_ME if is_me else COLOR_OTHER
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16 if is_me else 4
	style.corner_radius_bottom_right = 4 if is_me else 16
	style.shadow_color = Color(0, 0, 0, 0.1)
	style.shadow_size = 2
	style.shadow_offset = Vector2(0, 1)
	
	bg.add_theme_stylebox_override("panel", style)
	
	# Align to right if "me", left if "other"
	if is_me:
		size_flags_horizontal = SIZE_SHRINK_END
	else:
		size_flags_horizontal = SIZE_SHRINK_BEGIN
		
	# Text colors: dark gray so it's readable on green/white
	label.add_theme_color_override("default_color", Color(0.2, 0.2, 0.2))
	time_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	
	# Start hidden and scaled down for animation
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	pivot_offset = Vector2(bg.size.x if is_me else 0, bg.size.y)
	
func animate_in() -> void:
	# Update pivot to bottom corner based on sender
	await get_tree().process_frame
	pivot_offset = Vector2(size.x if _is_me else 0, size.y)
	
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.4)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
