extends Node

# DataManager: Carga y expone el contenido de modules.json

var data: Dictionary = {}

func _ready() -> void:
	load_data()

func load_data() -> void:
	var path := "res://data/modules.json"
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var text := file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(text)
		if parsed is Dictionary:
			data = parsed
		else:
			push_error("DataManager: modules.json tiene formato inválido.")
			data = {"modules": []}
	else:
		push_error("DataManager: No se pudo abrir modules.json")
		data = {"modules": []}

func get_modules() -> Array:
	return data.get("modules", [])

func get_module(module_id: int) -> Dictionary:
	for m in get_modules():
		if m.get("id", -1) == module_id:
			return m
	return {}

func get_lesson(module_id: int, lesson_id: String) -> Dictionary:
	var module := get_module(module_id)
	for lesson in module.get("lessons", []):
		if lesson.get("id", "") == lesson_id:
			return lesson
	return {}
