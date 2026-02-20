extends Control

# Vista de detalle de módulo — lista lecciones y botón de examen

const LESSONS_TOTAL := 4

# 🎨 Palette
const ACCENT := Color(0.29, 0.56, 1.0)
const ACCENT_SOFT := Color(0.29, 0.56, 1.0, 0.12)
const GREEN := Color(0.24, 0.82, 0.52)
const GREEN_SOFT := Color(0.24, 0.82, 0.52, 0.12)
const TEXT_PRIMARY := Color(0.92, 0.93, 0.98)
const TEXT_SECONDARY := Color(0.5, 0.55, 0.7)
const BORDER_DEFAULT := Color(0.18, 0.2, 0.32, 0.5)

@onready var module_title: Label = $VBox/Header/ModuleTitle
@onready var module_desc: Label = $VBox/ModuleDesc
@onready var lessons_container: VBoxContainer = $VBox/ScrollContainer/LessonsContainer
@onready var exam_button: Button = $VBox/ExamButton
@onready var back_button: Button = $VBox/Header/BackButton

var _module_id: int = 0
var _module_data: Dictionary = {}

func setup(module_id: int) -> void:
	_module_id = module_id
	_module_data = DataManager.get_module(module_id)
	_build_ui()

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

func _build_ui() -> void:
	module_title.text = "%s  %s" % [_module_data.get("icon", "📌"), _module_data.get("title", "")]
	module_desc.text = _module_data.get("description", "")

	var lessons: Array = _module_data.get("lessons", [])
	for lesson in lessons:
		_create_lesson_row(lesson)

	_update_exam_button()

func _create_lesson_row(lesson: Dictionary) -> void:
	var lid: String = lesson.get("id", "")
	var completed: bool = ProgressManager.is_lesson_completed(_module_id, lid)

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 100)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.text = "%s    %s" % [("✅" if completed else "📖"), lesson.get("title", "")]
	btn.add_theme_font_size_override("font_size", 26)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var style := StyleBoxFlat.new()
	style.bg_color = GREEN_SOFT if completed else Color(0.10, 0.11, 0.18, 0.95)
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_color = Color(0.24, 0.82, 0.52, 0.35) if completed else BORDER_DEFAULT
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	style.shadow_color = Color(0, 0, 0, 0.2)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 3)
	btn.add_theme_stylebox_override("normal", style)

	var hover := style.duplicate()
	hover.bg_color = style.bg_color.lightened(0.06)
	hover.border_color = ACCENT if not completed else GREEN
	btn.add_theme_stylebox_override("hover", hover)

	var press := style.duplicate()
	press.bg_color = style.bg_color.lightened(0.1)
	btn.add_theme_stylebox_override("pressed", press)

	btn.add_theme_color_override("font_color", GREEN if completed else TEXT_PRIMARY)
	btn.pressed.connect(_on_lesson_pressed.bind(lid, lesson.get("title", ""), lesson.get("content", "")))
	lessons_container.add_child(btn)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	lessons_container.add_child(spacer)

func _update_exam_button() -> void:
	var done: int = ProgressManager.get_lessons_completed_count(_module_id)
	var exam_unlocked: bool = done >= LESSONS_TOTAL
	exam_button.disabled = not exam_unlocked
	var best: int = ProgressManager.get_best_score(_module_id)

	var style := StyleBoxFlat.new()
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.content_margin_top = 18
	style.content_margin_bottom = 18
	style.content_margin_left = 24
	style.content_margin_right = 24

	if exam_unlocked:
		if best >= 70:
			exam_button.text = "📝  Examen  ✅  Mejor: %d%%" % best
			style.bg_color = Color(0.1, 0.25, 0.15)
			style.border_color = GREEN
			exam_button.add_theme_color_override("font_color", GREEN)
		else:
			exam_button.text = "📝  Ir al Examen" + ("  •  Mejor: %d%%" % best if best > 0 else "")
			style.bg_color = ACCENT
			style.border_color = ACCENT.lightened(0.2)
			exam_button.add_theme_color_override("font_color", Color.WHITE)
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		style.shadow_color = Color(0.29, 0.56, 1.0, 0.3)
		style.shadow_size = 8
		style.shadow_offset = Vector2(0, 4)
	else:
		exam_button.text = "🔒  Completa las %d lecciones primero" % LESSONS_TOTAL
		style.bg_color = Color(0.1, 0.1, 0.15)
		style.border_color = BORDER_DEFAULT
		style.border_width_top = 1
		style.border_width_bottom = 1
		style.border_width_left = 1
		style.border_width_right = 1
		exam_button.add_theme_color_override("font_color", Color(0.35, 0.38, 0.5))

	exam_button.add_theme_stylebox_override("normal", style)

	var disabled_style := style.duplicate()
	disabled_style.bg_color = Color(0.1, 0.1, 0.15, 0.7)
	exam_button.add_theme_stylebox_override("disabled", disabled_style)

	var hover := style.duplicate()
	hover.bg_color = style.bg_color.lightened(0.08)
	exam_button.add_theme_stylebox_override("hover", hover)

func _on_lesson_pressed(lesson_id: String, title: String, content: String) -> void:
	var scene: Node = load("res://scenes/LessonView.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.setup(_module_id, lesson_id, title, content)
	queue_free()

func _on_exam_pressed() -> void:
	var scene: Node = load("res://scenes/ExamView.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.setup(_module_id)
	queue_free()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ModuleList.tscn")
