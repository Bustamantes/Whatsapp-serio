extends Control

# Pantalla de progreso

const ProgressManager := preload("res://scripts/progress_manager.gd")

const LESSONS := [
	{"id": "enviar_mensaje", "titulo": "Enviar un Mensaje", "icono": "💬"},
	{"id": "hacer_llamada", "titulo": "Hacer una Llamada", "icono": "📞"},
	{"id": "enviar_foto", "titulo": "Enviar una Foto", "icono": "📷"},
	{"id": "crear_grupo", "titulo": "Crear un Grupo", "icono": "👥"},
	{"id": "enviar_audio", "titulo": "Enviar un Audio", "icono": "🎤"},
	{"id": "estados", "titulo": "Ver Estados", "icono": "⭐"},
]

@onready var list_container: VBoxContainer = %ListContainer
@onready var progress_label: Label = %ProgressLabel
@onready var progress_bar: ProgressBar = %TotalProgressBar

func _ready() -> void:
	ProgressManager.cargar()
	var total: int = LESSONS.size()
	var done: int = ProgressManager.total_completadas()
	progress_label.text = "%d de %d lecciones completadas" % [done, total]
	progress_bar.value = float(done) / float(total) * 100.0

	for lesson in LESSONS:
		var completada: bool = ProgressManager.esta_completada(lesson["id"])
		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 16)
		hbox.custom_minimum_size = Vector2(0, 70)

		# Ícono de estado
		var status_lbl := Label.new()
		status_lbl.text = "✅" if completada else "⬜"
		status_lbl.add_theme_font_size_override("font_size", 32)
		hbox.add_child(status_lbl)

		# Emoji de lección
		var icon_lbl := Label.new()
		icon_lbl.text = lesson["icono"]
		icon_lbl.add_theme_font_size_override("font_size", 32)
		hbox.add_child(icon_lbl)

		# Título
		var title_lbl := Label.new()
		title_lbl.text = lesson["titulo"]
		title_lbl.add_theme_font_size_override("font_size", 28)
		title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if completada:
			title_lbl.add_theme_color_override("font_color", Color(0.18, 0.8, 0.44))
		else:
			title_lbl.add_theme_color_override("font_color", Color(0.55, 0.55, 0.6))
		hbox.add_child(title_lbl)

		list_container.add_child(hbox)

		# Separador
		var sep := HSeparator.new()
		sep.add_theme_color_override("separator_color", Color(0.22, 0.22, 0.26))
		list_container.add_child(sep)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
