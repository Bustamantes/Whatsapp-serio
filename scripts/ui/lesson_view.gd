extends Control

# Vista de lectura de lección

# 🎨 Palette
const ACCENT := Color(0.29, 0.56, 1.0)
const GREEN := Color(0.24, 0.82, 0.52)
const TEXT_PRIMARY := Color(0.92, 0.93, 0.98)
const BORDER_DEFAULT := Color(0.18, 0.2, 0.32, 0.5)

@onready var title_label: Label = $VBox/Header/TitleLabel
@onready var content_label: Label = $VBox/ScrollContainer/ContentLabel
@onready var complete_button: Button = $VBox/CompleteButton
@onready var back_button: Button = $VBox/Header/BackButton
@onready var completed_banner: Label = $VBox/CompletedBanner

var _module_id: int = 0
var _lesson_id: String = ""
var _already_completed: bool = false

func _ready() -> void:
	_style_back_button()

func _style_back_button() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.12, 0.13, 0.2, 0.8)
	s.corner_radius_top_left = 14
	s.corner_radius_top_right = 14
	s.corner_radius_bottom_left = 14
	s.corner_radius_bottom_right = 14
	s.border_width_top = 1
	s.border_width_bottom = 1
	s.border_width_left = 1
	s.border_width_right = 1
	s.border_color = BORDER_DEFAULT
	s.content_margin_left = 16
	s.content_margin_right = 16
	back_button.add_theme_stylebox_override("normal", s)
	var hover := s.duplicate()
	hover.bg_color = s.bg_color.lightened(0.1)
	back_button.add_theme_stylebox_override("hover", hover)
	back_button.add_theme_color_override("font_color", TEXT_PRIMARY)
	back_button.add_theme_font_size_override("font_size", 22)

func setup(module_id: int, lesson_id: String, lesson_title: String, content: String) -> void:
	_module_id = module_id
	_lesson_id = lesson_id
	_already_completed = ProgressManager.is_lesson_completed(module_id, lesson_id)
	title_label.text = lesson_title
	content_label.text = content
	_update_ui()
	_style_complete_button()

func _style_complete_button() -> void:
	var style := StyleBoxFlat.new()
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.content_margin_top = 18
	style.content_margin_bottom = 18
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.shadow_color = Color(0, 0, 0, 0.3)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 3)

	if _already_completed:
		style.bg_color = Color(0.1, 0.22, 0.14)
		style.border_color = GREEN
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		complete_button.add_theme_color_override("font_color", GREEN)
	else:
		style.bg_color = ACCENT
		style.border_color = ACCENT.lightened(0.2)
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		style.shadow_color = Color(0.29, 0.56, 1.0, 0.35)
		complete_button.add_theme_color_override("font_color", Color.WHITE)

	complete_button.add_theme_stylebox_override("normal", style)

	var hover := style.duplicate()
	hover.bg_color = style.bg_color.lightened(0.08)
	complete_button.add_theme_stylebox_override("hover", hover)

	var disabled := style.duplicate()
	disabled.bg_color = Color(0.1, 0.22, 0.14, 0.6)
	complete_button.add_theme_stylebox_override("disabled", disabled)

func _update_ui() -> void:
	if _already_completed:
		complete_button.text = "✅  Ya completada"
		complete_button.disabled = true
		completed_banner.visible = true
	else:
		complete_button.text = "✅  Marcar como completada"
		complete_button.disabled = false
		completed_banner.visible = false

func _on_complete_pressed() -> void:
	ProgressManager.mark_lesson_completed(_module_id, _lesson_id)
	var done := ProgressManager.get_lessons_completed_count(_module_id)
	if done >= 4:
		ProgressManager.unlock_exam(_module_id)

	complete_button.text = "✅  ¡Completada!"
	complete_button.disabled = true
	completed_banner.visible = true
	_already_completed = true
	_style_complete_button()

	await get_tree().create_timer(1.0).timeout
	_go_back()

func _on_back_pressed() -> void:
	_go_back()

func _go_back() -> void:
	var scene: Node = load("res://scenes/ModuleDetail.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.setup(_module_id)
	queue_free()
