extends Control

# Vista del examen — preguntas aleatorizadas, corrección inmediata

# 🎨 Palette
const ACCENT := Color(0.29, 0.56, 1.0)
const GREEN := Color(0.24, 0.82, 0.52)
const GREEN_SOFT := Color(0.24, 0.82, 0.52, 0.12)
const RED := Color(0.92, 0.33, 0.33)
const RED_SOFT := Color(0.92, 0.33, 0.33, 0.12)
const GOLD := Color(1.0, 0.82, 0.28)
const CARD_BG := Color(0.10, 0.11, 0.18, 0.95)
const TEXT_PRIMARY := Color(0.92, 0.93, 0.98)
const TEXT_SECONDARY := Color(0.5, 0.55, 0.7)
const BORDER_DEFAULT := Color(0.18, 0.2, 0.32, 0.5)

@onready var question_label: Label = $VBox/QuestionLabel
@onready var options_container: VBoxContainer = $VBox/OptionsContainer
@onready var feedback_label: Label = $VBox/FeedbackLabel
@onready var next_button: Button = $VBox/NextButton
@onready var progress_bar: ProgressBar = $VBox/ProgressBar
@onready var score_label: Label = $VBox/ScoreLabel
@onready var title_label: Label = $VBox/Header/TitleLabel
@onready var back_button: Button = $VBox/Header/BackButton

var _module_id: int = 0
var _questions: Array = []
var _current_index: int = 0
var _score: int = 0
var _answered: bool = false

func _ready() -> void:
	_style_buttons()

func _style_buttons() -> void:
	# Back button
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

	# Next button (accent)
	_style_next_button()

	# Progress bar
	var bar_bg := StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.12, 0.13, 0.2)
	bar_bg.corner_radius_top_left = 5
	bar_bg.corner_radius_top_right = 5
	bar_bg.corner_radius_bottom_left = 5
	bar_bg.corner_radius_bottom_right = 5
	progress_bar.add_theme_stylebox_override("background", bar_bg)
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = ACCENT
	bar_fill.corner_radius_top_left = 5
	bar_fill.corner_radius_top_right = 5
	bar_fill.corner_radius_bottom_left = 5
	bar_fill.corner_radius_bottom_right = 5
	progress_bar.add_theme_stylebox_override("fill", bar_fill)

func _style_next_button() -> void:
	var ns := StyleBoxFlat.new()
	ns.bg_color = ACCENT
	ns.corner_radius_top_left = 20
	ns.corner_radius_top_right = 20
	ns.corner_radius_bottom_left = 20
	ns.corner_radius_bottom_right = 20
	ns.border_width_top = 2
	ns.border_width_bottom = 2
	ns.border_width_left = 2
	ns.border_width_right = 2
	ns.border_color = ACCENT.lightened(0.2)
	ns.content_margin_top = 18
	ns.content_margin_bottom = 18
	ns.shadow_color = Color(0.29, 0.56, 1.0, 0.3)
	ns.shadow_size = 6
	ns.shadow_offset = Vector2(0, 3)
	next_button.add_theme_stylebox_override("normal", ns)
	var hover := ns.duplicate()
	hover.bg_color = ns.bg_color.lightened(0.1)
	next_button.add_theme_stylebox_override("hover", hover)
	next_button.add_theme_color_override("font_color", Color.WHITE)

func setup(module_id: int) -> void:
	_module_id = module_id
	var module_data := DataManager.get_module(module_id)
	title_label.text = "📝  Examen: %s" % module_data.get("title", "")

	var raw_questions: Array = module_data.get("exam", {}).get("questions", [])
	_questions = raw_questions.duplicate()
	_questions.shuffle()
	_current_index = 0
	_score = 0

	progress_bar.max_value = _questions.size()
	progress_bar.value = 0
	score_label.text = ""
	feedback_label.text = ""
	feedback_label.visible = false
	next_button.visible = false

	_show_question()

func _show_question() -> void:
	if _current_index >= _questions.size():
		_finish_exam()
		return

	_answered = false
	var q: Dictionary = _questions[_current_index]
	question_label.text = "Pregunta %d de %d\n\n%s" % [_current_index + 1, _questions.size(), q.get("text", "")]
	feedback_label.text = ""
	feedback_label.visible = false
	next_button.visible = false
	score_label.text = "✅ %d de %d correctas" % [_score, _current_index]
	progress_bar.value = _current_index

	for child in options_container.get_children():
		child.queue_free()

	var shuffled := _shuffled_choices(q)
	var choices: Array = shuffled["choices"]
	var correct_idx: int = shuffled["correct_index"]

	for i in choices.size():
		var btn := Button.new()
		btn.text = choices[i]
		btn.custom_minimum_size = Vector2(0, 88)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.add_theme_font_size_override("font_size", 26)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

		var style := StyleBoxFlat.new()
		style.bg_color = CARD_BG
		style.corner_radius_top_left = 18
		style.corner_radius_top_right = 18
		style.corner_radius_bottom_left = 18
		style.corner_radius_bottom_right = 18
		style.border_width_top = 1
		style.border_width_bottom = 1
		style.border_width_left = 1
		style.border_width_right = 1
		style.border_color = BORDER_DEFAULT
		style.content_margin_left = 22
		style.content_margin_right = 22
		style.content_margin_top = 14
		style.content_margin_bottom = 14
		style.shadow_color = Color(0, 0, 0, 0.15)
		style.shadow_size = 3
		style.shadow_offset = Vector2(0, 2)
		btn.add_theme_stylebox_override("normal", style)

		var hover_s := style.duplicate()
		hover_s.bg_color = style.bg_color.lightened(0.08)
		hover_s.border_color = ACCENT
		btn.add_theme_stylebox_override("hover", hover_s)

		var press := style.duplicate()
		press.bg_color = style.bg_color.lightened(0.12)
		btn.add_theme_stylebox_override("pressed", press)

		btn.add_theme_color_override("font_color", TEXT_PRIMARY)
		btn.pressed.connect(_on_answer_selected.bind(i, correct_idx, btn))
		options_container.add_child(btn)

func _on_answer_selected(chosen_idx: int, correct_idx: int, chosen_btn: Button) -> void:
	if _answered:
		return
	_answered = true

	for child in options_container.get_children():
		if child is Button:
			child.disabled = true

	feedback_label.visible = true

	if chosen_idx == correct_idx:
		_score += 1
		feedback_label.text = "✅  ¡Correcto!"
		feedback_label.add_theme_color_override("font_color", GREEN)
		var style: StyleBoxFlat = chosen_btn.get_theme_stylebox("normal").duplicate()
		style.bg_color = GREEN_SOFT
		style.border_color = GREEN
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		chosen_btn.add_theme_stylebox_override("normal", style)
		chosen_btn.add_theme_color_override("font_color", GREEN)
	else:
		feedback_label.text = "❌  Respuesta incorrecta"
		feedback_label.add_theme_color_override("font_color", RED)
		var style: StyleBoxFlat = chosen_btn.get_theme_stylebox("normal").duplicate()
		style.bg_color = RED_SOFT
		style.border_color = RED
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		chosen_btn.add_theme_stylebox_override("normal", style)
		chosen_btn.add_theme_color_override("font_color", RED)
		# Marcar la correcta en verde
		var children := options_container.get_children()
		if correct_idx < children.size():
			var correct_btn: Button = children[correct_idx]
			var correct_style: StyleBoxFlat = correct_btn.get_theme_stylebox("normal").duplicate()
			correct_style.bg_color = GREEN_SOFT
			correct_style.border_color = GREEN
			correct_style.border_width_top = 2
			correct_style.border_width_bottom = 2
			correct_style.border_width_left = 2
			correct_style.border_width_right = 2
			correct_btn.add_theme_stylebox_override("normal", correct_style)
			correct_btn.add_theme_color_override("font_color", GREEN)

	score_label.text = "✅ %d de %d correctas" % [_score, _current_index + 1]
	next_button.visible = true
	next_button.text = "Siguiente  →" if _current_index + 1 < _questions.size() else "Ver resultado  🎉"

func _on_next_pressed() -> void:
	_current_index += 1
	_show_question()

func _finish_exam() -> void:
	var total := _questions.size()
	var percent := int(_score * 100 / total) if total > 0 else 0
	ProgressManager.set_best_score(_module_id, percent)

	if percent >= 70:
		ProgressManager.unlock_next_module(_module_id)

	for child in options_container.get_children():
		child.queue_free()

	var passed := percent >= 70
	question_label.text = "🎓  Examen terminado"
	feedback_label.visible = true
	feedback_label.text = "%s\n\nPuntaje: %d / %d  (%d%%)\n\n%s" % [
		("🎉  ¡Felicitaciones! Aprobaste." if passed else "📚  Sigue practicando."),
		_score, total, percent,
		("El siguiente módulo se ha desbloqueado." if passed else "Puedes repetir el examen.")
	]
	feedback_label.add_theme_color_override("font_color", GREEN if passed else GOLD)
	feedback_label.add_theme_font_size_override("font_size", 28)
	progress_bar.value = total
	score_label.text = "Mejor puntaje: %d%%" % ProgressManager.get_best_score(_module_id)

	# Cambiar botón a "Volver"
	next_button.text = "Volver al Módulo  ←"
	next_button.visible = true
	if next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.disconnect(_on_next_pressed)
	if not next_button.pressed.is_connected(_on_back_pressed):
		next_button.pressed.connect(_on_back_pressed)

	# Green styling if passed
	if passed:
		var ns := StyleBoxFlat.new()
		ns.bg_color = GREEN
		ns.corner_radius_top_left = 20
		ns.corner_radius_top_right = 20
		ns.corner_radius_bottom_left = 20
		ns.corner_radius_bottom_right = 20
		ns.shadow_color = Color(0.24, 0.82, 0.52, 0.35)
		ns.shadow_size = 8
		ns.shadow_offset = Vector2(0, 4)
		ns.content_margin_top = 18
		ns.content_margin_bottom = 18
		next_button.add_theme_stylebox_override("normal", ns)
		var hov := ns.duplicate()
		hov.bg_color = GREEN.lightened(0.1)
		next_button.add_theme_stylebox_override("hover", hov)

func _shuffled_choices(question: Dictionary) -> Dictionary:
	var choices: Array = question.get("choices", []).duplicate()
	var mapping := range(choices.size())
	mapping.shuffle()
	var shuffled := []
	for idx in mapping:
		shuffled.append(choices[idx])
	var correct_index: int = mapping.find(question.get("answer", 0))
	return {"choices": shuffled, "correct_index": correct_index}

func _on_back_pressed() -> void:
	var scene: Node = load("res://scenes/ModuleDetail.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.setup(_module_id)
	queue_free()
