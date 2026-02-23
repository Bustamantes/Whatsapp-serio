extends Control

# Duolingo-style lesson path

const NODE_SZ := 100
const EXAM_SZ := 110
const V_GAP := 160
const SNAKE_AMP := 130.0
const SECT_H := 80
const ICONS := ["⭐", "📹", "📖", "🎧"]

const C_ACTIVE := Color(0.15, 0.83, 0.41) # Premium Green
const C_ACTIVE_SH := Color(0.07, 0.55, 0.24)
const C_DONE := Color(0.29, 0.56, 1.0) # Premium Blue
const C_DONE_SH := Color(0.18, 0.37, 0.75)
const C_LOCK := Color(0.25, 0.28, 0.35)
const C_LOCK_SH := Color(0.16, 0.18, 0.25)
const C_GOLD := Color(1.0, 0.78, 0.1)
const C_GOLD_SH := Color(0.8, 0.55, 0.0)
const C_DIM := Color(0.5, 0.55, 0.7)

@onready var scroll: ScrollContainer = $VBox/ScrollContainer
@onready var path_c: Control = $VBox/ScrollContainer/PathContainer
@onready var stats_bar: PanelContainer = $VBox/StatsBar
@onready var progress_lbl: Label = $VBox/StatsBar/HBox/ProgressLbl
@onready var nav_box: HBoxContainer = $VBox/BottomPanel/NavBox
@onready var nav_panel: PanelContainer = $VBox/BottomPanel

var _mods: Array = []
var _cx: float = 540.0
var _scroll_y: float = 0.0
var _found_active := false

func _ready() -> void:
	_cx = get_viewport_rect().size.x / 2.0
	_mods = DataManager.get_modules()
	_style_bars()
	_build_path()
	_build_nav()
	if _scroll_y > 250:
		await get_tree().process_frame
		scroll.scroll_vertical = int(_scroll_y - 250)

func _style_bars() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.09, 0.1, 0.14)
	s.border_width_bottom = 1
	s.border_color = Color(0.15, 0.17, 0.22)
	stats_bar.add_theme_stylebox_override("panel", s)
	var ns := StyleBoxFlat.new()
	ns.bg_color = Color(0.09, 0.1, 0.14)
	ns.border_width_top = 1
	ns.border_color = Color(0.15, 0.17, 0.22)
	nav_panel.add_theme_stylebox_override("panel", ns)

func _build_nav() -> void:
	var icons := ["🏠", "📦", "👤", "❤️", "🎓", "⚙️"]
	var labels := ["Inicio", "Tesoro", "Perfil", "Vidas", "Liga", "Ajustes"]
	for i in icons.size():
		var vb := VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		vb.add_theme_constant_override("separation", 2)
		var il := Label.new()
		il.text = icons[i]
		il.add_theme_font_size_override("font_size", 30)
		il.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(il)
		var tl := Label.new()
		tl.text = labels[i]
		tl.add_theme_font_size_override("font_size", 12)
		tl.add_theme_color_override("font_color", C_ACTIVE if i == 0 else C_DIM)
		tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(tl)
		nav_box.add_child(vb)

func _build_path() -> void:
	for c in path_c.get_children():
		c.queue_free()
	var y := 20.0
	var gi := 0
	var done := 0
	var total := 0
	_found_active = false
	var vw := get_viewport_rect().size.x

	for m in _mods:
		var mid: int = m.get("id", 0)
		var unlocked := ProgressManager.is_module_unlocked(mid)
		# Section header
		_section(m, y, unlocked, vw)
		y += SECT_H + 30
		# Lessons
		var lessons: Array = m.get("lessons", [])
		for i in lessons.size():
			var ls = lessons[i]
			var lid := str(ls.get("id", ""))
			var comp := ProgressManager.is_lesson_completed(mid, lid)
			var act := unlocked and not comp
			if comp: done += 1
			total += 1
			var x := _sx(gi, NODE_SZ)
			
			if act and not _found_active:
				_found_active = true
				_scroll_y = y
				_cont_label(x + NODE_SZ / 2.0, y - 55)
			
			# Personaje decorativo cada cierto tiempo
			if gi % 5 == 2:
				_character(vw - 120.0 if x < _cx else 40.0, y + 20.0)
				
			_lesson_node(x, y, i, comp, act, mid, lid, ls.get("title",""), ls.get("content",""))
			y += V_GAP
			gi += 1
		# Exam
		var ld := ProgressManager.get_lessons_completed_count(mid)
		var bs := ProgressManager.get_best_score(mid)
		var ep := bs >= 70
		var ea := ld >= 4 and unlocked
		var eact := ea and not ep
		var x := _sx(gi, EXAM_SZ)
		if eact and not _found_active:
			_found_active = true
			_scroll_y = y
			_cont_label(x + EXAM_SZ / 2.0, y - 45)
		_exam_node(x, y, mid, ep, eact, ea)
		y += V_GAP + 40
		gi += 1

	path_c.custom_minimum_size = Vector2(0, y + 40)
	progress_lbl.text = "🔥 %d" % done

func _sx(idx: int, sz: int) -> float:
	return _cx + sin(idx * 0.7) * SNAKE_AMP - sz / 2.0

func _section(m: Dictionary, y: float, unlocked: bool, vw: float) -> void:
	var p := PanelContainer.new()
	p.position = Vector2(40, y)
	p.size = Vector2(vw - 80, SECT_H + 20)
	var s := StyleBoxFlat.new()
	# Color de sección más rico
	s.bg_color = C_ACTIVE if unlocked else C_LOCK
	s.corner_radius_top_left = 20
	s.corner_radius_top_right = 20
	s.corner_radius_bottom_left = 20
	s.corner_radius_bottom_right = 20
	s.content_margin_left = 24
	s.content_margin_right = 24
	s.content_margin_top = 16
	s.content_margin_bottom = 16
	# Sombra profunda estilo duolingo
	s.shadow_color = C_ACTIVE_SH if unlocked else C_LOCK_SH
	s.shadow_size = 0
	s.shadow_offset = Vector2(0, 10)
	p.add_theme_stylebox_override("panel", s)
	
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 20)
	
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation", -2)
	
	var sub := Label.new()
	sub.text = "ETAPA %d, SECCIÓN 1" % m.get("id", 0)
	sub.add_theme_font_size_override("font_size", 14)
	sub.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	sub.uppercase = true
	vb.add_child(sub)
	
	var tl := Label.new()
	tl.text = m.get("title", "")
	tl.add_theme_font_size_override("font_size", 24)
	tl.add_theme_color_override("font_color", Color.WHITE)
	tl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(tl)
	hb.add_child(vb)
	
	# Ícono de libro a la derecha
	var icon := Label.new()
	icon.text = "📓"
	icon.add_theme_font_size_override("font_size", 32)
	hb.add_child(icon)
	
	p.add_child(hb)
	path_c.add_child(p)

func _cont_label(cx: float, y: float) -> void:
	# Contenedor para el globo
	var container := Control.new()
	container.position = Vector2(cx - 75, y)
	
	var p := PanelContainer.new()
	p.size = Vector2(150, 42)
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.09, 0.13, 0.22)
	s.border_width_left = 2
	s.border_width_top = 2
	s.border_width_right = 2
	s.border_width_bottom = 2
	s.border_color = Color(0.15, 0.2, 0.35)
	s.corner_radius_top_left = 12
	s.corner_radius_top_right = 12
	s.corner_radius_bottom_left = 12
	s.corner_radius_bottom_right = 12
	p.add_theme_stylebox_override("panel", s)
	
	var lbl := Label.new()
	lbl.text = "CONTINUAR"
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(0.18, 0.72, 0.96))
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	p.add_child(lbl)
	
	# Tip del globo (triángulo pequeño hacia abajo)
	var tip := ColorRect.new()
	tip.color = Color(0.09, 0.13, 0.22)
	tip.size = Vector2(16, 16)
	tip.rotation_degrees = 45
	tip.position = Vector2(75 - 8, 42 - 8)
	
	container.add_child(tip)
	container.add_child(p)
	path_c.add_child(container)
	
	# Animación flotante
	var tw := create_tween().set_loops()
	tw.tween_property(container, "position:y", container.position.y - 10, 0.8).set_trans(Tween.TRANS_SINE)
	tw.tween_property(container, "position:y", container.position.y, 0.8).set_trans(Tween.TRANS_SINE)

func _circle_style(color: Color, shadow: Color, radius: int, sh_off: float = 8.0) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = radius
	s.corner_radius_top_right = radius
	s.corner_radius_bottom_left = radius
	s.corner_radius_bottom_right = radius
	s.shadow_color = shadow
	s.shadow_size = 0
	s.shadow_offset = Vector2(0, sh_off)
	return s

func _ring(x: float, y: float, sz: int, color: Color) -> void:
	var r := Panel.new()
	var rs := sz + 24
	r.position = Vector2(x - 12, y - 12)
	r.size = Vector2(rs, rs)
	r.pivot_offset = Vector2(rs/2, rs/2)
	var st := StyleBoxFlat.new()
	st.bg_color = Color(0, 0, 0, 0) # Hueco
	st.corner_radius_top_left = rs / 2
	st.corner_radius_top_right = rs / 2
	st.corner_radius_bottom_left = rs / 2
	st.corner_radius_bottom_right = rs / 2
	st.border_width_left = 6
	st.border_width_top = 6
	st.border_width_right = 6
	st.border_width_bottom = 6
	st.border_color = color.lerp(Color.BLACK, 0.2)
	r.add_theme_stylebox_override("panel", st)
	path_c.add_child(r)
	
	# Animación de pulso/escala
	var tw := create_tween().set_loops()
	tw.tween_property(r, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_SINE)
	tw.tween_property(r, "scale", Vector2(0.95, 0.95), 1.0).set_trans(Tween.TRANS_SINE)

func _lesson_node(x: float, y: float, idx: int, comp: bool, act: bool,
		mid: int, lid: String, title: String, content: String) -> void:
	if act: _ring(x, y, NODE_SZ, C_ACTIVE)
	
	var btn := Button.new()
	btn.position = Vector2(x, y)
	btn.size = Vector2(NODE_SZ, NODE_SZ)
	btn.text = ICONS[idx % ICONS.size()]
	btn.add_theme_font_size_override("font_size", 38)
	
	var bg: Color; var sh: Color
	if act:
		bg = C_ACTIVE; sh = C_ACTIVE_SH
	elif comp:
		bg = C_GOLD if mid % 2 == 0 else C_ACTIVE # Variedad de colores
		sh = C_GOLD_SH if mid % 2 == 0 else C_ACTIVE_SH
	else:
		bg = C_LOCK; sh = C_LOCK_SH
		btn.disabled = true
	
	btn.add_theme_stylebox_override("normal", _circle_style(bg, sh, NODE_SZ / 2.0))
	
	if not btn.disabled:
		var h := _circle_style(bg.lightened(0.1), sh, NODE_SZ / 2.0)
		btn.add_theme_stylebox_override("hover", h)
		var p := _circle_style(bg.darkened(0.1), sh, NODE_SZ / 2.0, 2.0)
		btn.add_theme_stylebox_override("pressed", p)
		btn.pressed.connect(_on_lesson.bind(mid, lid, title, content))
		
	# Efecto de texto blanco para activos
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_color_override("font_disabled_color", Color(0.4, 0.45, 0.55))
	
	path_c.add_child(btn)

func _exam_node(x: float, y: float, mid: int, passed: bool, act: bool, avail: bool) -> void:
	if act: _ring(x, y, EXAM_SZ, C_GOLD)
	
	var btn := Button.new()
	btn.position = Vector2(x, y)
	btn.size = Vector2(EXAM_SZ, EXAM_SZ)
	btn.text = "🏆"
	btn.add_theme_font_size_override("font_size", 44)
	
	var bg: Color; var sh: Color
	if passed or act:
		bg = C_GOLD; sh = C_GOLD_SH
	else:
		bg = C_LOCK; sh = C_LOCK_SH
		if not avail: btn.disabled = true
		
	btn.add_theme_stylebox_override("normal", _circle_style(bg, sh, EXAM_SZ / 2, 10.0))
	
	if not btn.disabled:
		var h := _circle_style(bg.lightened(0.1), sh, EXAM_SZ / 2, 10.0)
		btn.add_theme_stylebox_override("hover", h)
		var p := _circle_style(bg.darkened(0.1), sh, EXAM_SZ / 2, 2.0)
		btn.add_theme_stylebox_override("pressed", p)
		btn.pressed.connect(_on_exam.bind(mid))
		
	btn.add_theme_color_override("font_color", Color.WHITE)
	path_c.add_child(btn)

func _on_lesson(mid: int, lid: String, title: String, content: String) -> void:
	var sc: Node = load("res://scenes/LessonView.tscn").instantiate()
	get_tree().root.add_child(sc)
	sc.setup(mid, lid, title, content)
	queue_free()

func _on_exam(mid: int) -> void:
	var sc: Node = load("res://scenes/ExamView.tscn").instantiate()
	get_tree().root.add_child(sc)
	sc.setup(mid)
	queue_free()

func _character(x: float, y: float) -> void:
	var chars := ["🦉", "🐻", "🦊", "🦁", "🤖"]
	var lbl := Label.new()
	lbl.text = chars[randi() % chars.size()]
	lbl.position = Vector2(x, y)
	lbl.add_theme_font_size_override("font_size", 64)
	path_c.add_child(lbl)
	
	# Animación suave de flotación
	var tw := create_tween().set_loops()
	tw.set_trans(Tween.TRANS_SINE)
	tw.tween_property(lbl, "position:y", y - 12, 1.5)
	tw.tween_property(lbl, "position:y", y, 1.5)
