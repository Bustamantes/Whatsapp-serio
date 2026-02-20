extends Control

# Pantalla de carga con barra de progreso

@onready var title_label: Label = $VBox/TitleLabel
@onready var subtitle_label: Label = $VBox/SubtitleLabel
@onready var progress_bar: ProgressBar = $VBox/ProgressBar
@onready var logo_label: Label = $VBox/LogoLabel

const ACCENT := Color(0.29, 0.56, 1.0)

func _ready() -> void:
	# Estilo visual del progress bar
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

	call_deferred("_start_loading")

func _start_loading() -> void:
	for i in range(21):
		progress_bar.value = i * 5
		await get_tree().create_timer(0.04).timeout
	progress_bar.value = 100
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/ModuleList.tscn")
