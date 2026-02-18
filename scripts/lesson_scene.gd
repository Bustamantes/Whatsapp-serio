extends Control

# Escena de lección con quiz interactivo

const ProgressManager := preload("res://scripts/progress_manager.gd")

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var instruction_label: Label = %InstructionLabel
@onready var options_container: VBoxContainer = %OptionsContainer
@onready var feedback_label: Label = %FeedbackLabel
@onready var next_button: Button = %NextButton
@onready var title_label: Label = %TitleLabel

var lesson_id: String = ""
var current_step: int = 0
var total_steps: int = 0
var steps: Array = []

func setup(p_lesson_id: String, p_title: String, p_steps: Array) -> void:
	lesson_id = p_lesson_id
	steps = p_steps
	total_steps = steps.size()
	current_step = 0
	title_label.text = p_title
	_mostrar_paso()

func _mostrar_paso() -> void:
	if current_step >= total_steps:
		_leccion_completada()
		return

	var paso: Dictionary = steps[current_step]
	progress_bar.value = float(current_step) / float(total_steps) * 100.0
	instruction_label.text = paso["instruccion"]
	feedback_label.text = ""
	feedback_label.visible = false
	next_button.visible = false

	for child in options_container.get_children():
		child.queue_free()

	for opcion in paso["opciones"]:
		var btn := Button.new()
		btn.text = opcion["texto"]
		btn.custom_minimum_size = Vector2(0, 90)

		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.2, 0.24)
		style.corner_radius_top_left = 16
		style.corner_radius_top_right = 16
		style.corner_radius_bottom_left = 16
		style.corner_radius_bottom_right = 16
		style.content_margin_left = 24
		style.content_margin_right = 24
		style.content_margin_top = 12
		style.content_margin_bottom = 12
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_width_left = 2
		style.border_width_right = 2
		style.border_color = Color(0.32, 0.32, 0.38)
		btn.add_theme_stylebox_override("normal", style)

		var hover := style.duplicate()
		hover.border_color = Color(0.5, 0.5, 0.6)
		btn.add_theme_stylebox_override("hover", hover)

		btn.add_theme_font_size_override("font_size", 28)
		btn.add_theme_color_override("font_color", Color(0.9, 0.9, 0.92))
		btn.add_theme_color_override("font_hover_color", Color.WHITE)

		btn.pressed.connect(_on_opcion_seleccionada.bind(opcion["correcta"], btn))
		options_container.add_child(btn)

func _on_opcion_seleccionada(es_correcta: bool, btn: Button) -> void:
	feedback_label.visible = true

	if es_correcta:
		feedback_label.text = "✅ ¡Correcto!"
		feedback_label.add_theme_color_override("font_color", Color(0.18, 0.8, 0.44))
		var style: StyleBoxFlat = btn.get_theme_stylebox("normal").duplicate()
		style.bg_color = Color(0.18, 0.8, 0.44, 0.25)
		style.border_color = Color(0.18, 0.8, 0.44)
		btn.add_theme_stylebox_override("normal", style)
		next_button.visible = true
		for child in options_container.get_children():
			child.disabled = true
	else:
		feedback_label.text = "❌ Intenta de nuevo"
		feedback_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
		var style: StyleBoxFlat = btn.get_theme_stylebox("normal").duplicate()
		style.bg_color = Color(0.9, 0.3, 0.3, 0.15)
		style.border_color = Color(0.9, 0.3, 0.3)
		btn.add_theme_stylebox_override("normal", style)
		btn.disabled = true

func _on_next_pressed() -> void:
	current_step += 1
	_mostrar_paso()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _leccion_completada() -> void:
	# Guardar progreso
	ProgressManager.completar_leccion(lesson_id)

	progress_bar.value = 100
	instruction_label.text = "🎉 ¡Lección completada!"
	feedback_label.visible = false
	for child in options_container.get_children():
		child.queue_free()
	next_button.text = "VOLVER AL MENÚ"
	next_button.visible = true
	if next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.disconnect(_on_next_pressed)
	if not next_button.pressed.is_connected(_on_back_pressed):
		next_button.pressed.connect(_on_back_pressed)
