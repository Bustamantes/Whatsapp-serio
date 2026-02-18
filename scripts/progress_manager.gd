extends Node

# Manejo de progreso del usuario (guardado local)

const SAVE_PATH := "user://progress.cfg"

static var _completed: Array[String] = []
static var _loaded: bool = false

static func cargar() -> void:
	if _loaded:
		return
	_loaded = true
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		var raw: Variant = config.get_value("progreso", "completadas", [])
		_completed.clear()
		for item in raw:
			_completed.append(str(item))

static func guardar() -> void:
	var config := ConfigFile.new()
	config.set_value("progreso", "completadas", _completed)
	config.save(SAVE_PATH)

static func completar_leccion(lesson_id: String) -> void:
	if not _completed.has(lesson_id):
		_completed.append(lesson_id)
		guardar()

static func esta_completada(lesson_id: String) -> bool:
	cargar()
	return _completed.has(lesson_id)

static func obtener_completadas() -> Array[String]:
	cargar()
	return _completed

static func total_completadas() -> int:
	cargar()
	return _completed.size()
