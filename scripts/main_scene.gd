extends Control

# Menú principal estilo Duolingo con camino de lecciones

const LessonData := preload("res://scripts/lesson_data.gd")
const ProgressManager := preload("res://scripts/progress_manager.gd")
const LessonScenePath := "res://scenes/lesson_scene.tscn"

const BG_COLOR := Color(0.11, 0.11, 0.14)
const CIRCLE_SIZE := 120.0
const CIRCLE_LOCKED := Color(0.25, 0.27, 0.30)
const CIRCLE_ACTIVE := Color(0.22, 0.65, 0.95)
const CIRCLE_DONE := Color(0.18, 0.8, 0.44)
const BANNER_COLOR := Color(0.22, 0.65, 0.95)

const LESSONS := [
	{"id": "enviar_mensaje", "titulo": "Enviar un Mensaje", "icono": "💬"},
	{"id": "hacer_llamada", "titulo": "Hacer una Llamada", "icono": "📞"},
	{"id": "enviar_foto", "titulo": "Enviar una Foto", "icono": "📷"},
	{"id": "crear_grupo", "titulo": "Crear un Grupo", "icono": "👥"},
	{"id": "enviar_audio", "titulo": "Enviar un Audio", "icono": "🎤"},
	{"id": "estados", "titulo": "Ver Estados", "icono": "⭐"},
]

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var path_container: Control = %PathContainer
@onready var top_bar: HBoxContainer = %TopBar
@onready var banner: PanelContainer = %Banner
@onready var bottom_nav: HBoxContainer = %BottomNav

func _ready() -> void:
	ProgressManager.cargar()
	_crear_top_bar()
	_crear_banner()
	_crear_camino_lecciones()
	_crear_bottom_nav()

# --- Determinar lección activa ---
func _get_current_lesson() -> int:
	for i in LESSONS.size():
		if not ProgressManager.esta_completada(LESSONS[i]["id"]):
			return i
	return LESSONS.size()

# --- Barra superior ---
func _crear_top_bar() -> void:
	var completadas: int = ProgressManager.total_completadas()
	var stats := [
		{"icono": "📱", "valor": str(completadas) + "/" + str(LESSONS.size()), "color": Color(0.22, 0.65, 0.95)},
		{"icono": "🔥", "valor": "1", "color": Color(1, 0.6, 0.2)},
	]
	for stat in stats:
		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 6)
		var icon_lbl := Label.new()
		icon_lbl.text = stat["icono"]
		icon_lbl.add_theme_font_size_override("font_size", 28)
		hbox.add_child(icon_lbl)
		var val_lbl := Label.new()
		val_lbl.text = str(stat["valor"])
		val_lbl.add_theme_font_size_override("font_size", 28)
		val_lbl.add_theme_color_override("font_color", stat["color"])
		hbox.add_child(val_lbl)
		top_bar.add_child(hbox)

# --- Banner ---
func _crear_banner() -> void:
	var etapa_lbl: Label = banner.get_node("MarginContainer/VBox/EtapaLabel")
	var titulo_lbl: Label = banner.get_node("MarginContainer/VBox/TituloLabel")
	var current: int = _get_current_lesson()
	if current >= LESSONS.size():
		etapa_lbl.text = "¡FELICIDADES!"
		titulo_lbl.text = "Todas las lecciones completadas"
	else:
		etapa_lbl.text = "ETAPA 1, LECCIÓN %d" % (current + 1)
		titulo_lbl.text = LESSONS[current]["titulo"]

# --- Camino zigzag ---
func _crear_camino_lecciones() -> void:
	var viewport_w: float = get_viewport_rect().size.x
	var center_x: float = viewport_w / 2.0
	var offset_x: float = 120.0
	var start_y: float = 30.0
	var spacing_y: float = 180.0
	var positions: Array[int] = [0, -1, 0, 1, 0, -1]
	var current: int = _get_current_lesson()

	for i in LESSONS.size():
		var lesson: Dictionary = LESSONS[i]
		var x_pos: float = center_x + (positions[i % positions.size()] * offset_x) - (CIRCLE_SIZE / 2.0)
		var y_pos: float = start_y + (i * spacing_y)

		var circle: Button = _crear_circulo_leccion(lesson, i, current)
		circle.position = Vector2(x_pos, y_pos)
		path_container.add_child(circle)

		# "CONTINUAR" sobre la lección activa
		if i == current:
			var cont_lbl := Label.new()
			cont_lbl.text = "CONTINUAR"
			cont_lbl.add_theme_font_size_override("font_size", 24)
			cont_lbl.add_theme_color_override("font_color", Color.WHITE)
			cont_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cont_lbl.position = Vector2(x_pos - 30, y_pos - 40)
			cont_lbl.custom_minimum_size = Vector2(CIRCLE_SIZE + 60, 30)
			path_container.add_child(cont_lbl)

	path_container.custom_minimum_size.y = start_y + (LESSONS.size() * spacing_y) + 60

func _crear_circulo_leccion(data: Dictionary, index: int, current: int) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(CIRCLE_SIZE, CIRCLE_SIZE)
	btn.text = data["icono"]
	btn.clip_text = false

	var is_done: bool = ProgressManager.esta_completada(data["id"])
	var is_active: bool = (index == current)
	var is_locked: bool = (index > current)

	var color: Color
	if is_done:
		color = CIRCLE_DONE
	elif is_active:
		color = CIRCLE_ACTIVE
	else:
		color = CIRCLE_LOCKED

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = int(CIRCLE_SIZE / 2)
	style.corner_radius_top_right = int(CIRCLE_SIZE / 2)
	style.corner_radius_bottom_left = int(CIRCLE_SIZE / 2)
	style.corner_radius_bottom_right = int(CIRCLE_SIZE / 2)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 10
	style.content_margin_bottom = 10

	if is_active:
		style.border_width_top = 4
		style.border_width_bottom = 4
		style.border_width_left = 4
		style.border_width_right = 4
		style.border_color = CIRCLE_ACTIVE.lightened(0.3)

	style.shadow_color = Color(0, 0, 0, 0.4)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 4)
	btn.add_theme_stylebox_override("normal", style)

	var hover := style.duplicate()
	if not is_locked:
		hover.bg_color = color.lightened(0.12)
	btn.add_theme_stylebox_override("hover", hover)

	var pressed := style.duplicate()
	if not is_locked:
		pressed.bg_color = color.darkened(0.1)
	pressed.shadow_size = 1
	pressed.shadow_offset = Vector2(0, 1)
	btn.add_theme_stylebox_override("pressed", pressed)

	btn.add_theme_font_size_override("font_size", 44)

	if is_locked:
		btn.add_theme_color_override("font_color", Color(0.4, 0.42, 0.45))
		btn.disabled = true
		# Estilo deshabilitado
		var disabled_style := style.duplicate()
		btn.add_theme_stylebox_override("disabled", disabled_style)
	elif is_active:
		btn.add_theme_color_override("font_color", Color.WHITE)
	else:
		btn.add_theme_color_override("font_color", Color(0.9, 0.95, 0.9))

	if not is_locked:
		btn.pressed.connect(_on_lesson_pressed.bind(data["id"], data["titulo"]))

	return btn

# --- Barra inferior: Home, Progreso, Configuraciones ---
func _crear_bottom_nav() -> void:
	var items := [
		{"icono": "🏠", "label": "Home", "active": true},
		{"icono": "📊", "label": "Progreso", "active": false},
		{"icono": "⚙️", "label": "Ajustes", "active": false},
	]
	for item in items:
		var btn := Button.new()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 70)

		var vbox := VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE

		var icon_lbl := Label.new()
		icon_lbl.text = item["icono"]
		icon_lbl.add_theme_font_size_override("font_size", 28)
		icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		icon_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(icon_lbl)

		var name_lbl := Label.new()
		name_lbl.text = item["label"]
		name_lbl.add_theme_font_size_override("font_size", 16)
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if item["active"]:
			name_lbl.add_theme_color_override("font_color", CIRCLE_ACTIVE)
		else:
			name_lbl.add_theme_color_override("font_color", Color(0.45, 0.45, 0.5))
		vbox.add_child(name_lbl)

		# Estilo transparente
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0, 0, 0, 0)
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("hover", style)
		btn.add_theme_stylebox_override("pressed", style)

		btn.add_child(vbox)

		if item["label"] == "Progreso":
			btn.pressed.connect(_on_progreso_pressed)

		bottom_nav.add_child(btn)

func _on_progreso_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/progress_scene.tscn")

func _on_lesson_pressed(lesson_id: String, titulo: String) -> void:
	var packed_scene: PackedScene = load(LessonScenePath)
	var scene: Node = packed_scene.instantiate()
	var pasos: Array = LessonData.obtener_pasos(lesson_id)
	get_tree().root.add_child(scene)
	scene.setup(lesson_id, titulo, pasos)
	queue_free()
