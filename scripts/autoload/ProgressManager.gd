extends Node

# ProgressManager: Guarda y carga el progreso del usuario en user://progress.json

const SAVE_PATH := "user://progress.json"

var progress: Dictionary = {
	"unlocked_module": 1,
	"modules": {}
	# Formato: { "1": { "lessons_completed": [], "best_score": 0, "exam_unlocked": false } }
}

func _ready() -> void:
	load_progress()

# --- Carga ---
func load_progress() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f:
		var text := f.get_as_text()
		f.close()
		var parsed = JSON.parse_string(text)
		if parsed is Dictionary:
			progress = parsed
	else:
		save_progress()

# --- Guardado ---
func save_progress() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(progress))
		f.close()

# --- Módulos ---
func is_module_unlocked(module_id: int) -> bool:
	return module_id <= progress.get("unlocked_module", 1)

func unlock_next_module(current_module_id: int) -> void:
	var next := current_module_id + 1
	if next > progress.get("unlocked_module", 1):
		progress["unlocked_module"] = next
		save_progress()

# --- Lecciones ---
func _ensure_module_key(module_id: int) -> void:
	var key := str(module_id)
	if not progress["modules"].has(key):
		progress["modules"][key] = {
			"lessons_completed": [],
			"best_score": 0,
			"exam_unlocked": false
		}

func mark_lesson_completed(module_id: int, lesson_id: String) -> void:
	_ensure_module_key(module_id)
	var key := str(module_id)
	var arr: Array = progress["modules"][key]["lessons_completed"]
	if lesson_id not in arr:
		arr.append(lesson_id)
		save_progress()

func is_lesson_completed(module_id: int, lesson_id: String) -> bool:
	var key := str(module_id)
	if not progress["modules"].has(key):
		return false
	return lesson_id in progress["modules"][key]["lessons_completed"]

func get_lessons_completed_count(module_id: int) -> int:
	var key := str(module_id)
	if not progress["modules"].has(key):
		return 0
	return progress["modules"][key]["lessons_completed"].size()

# --- Examen ---
func is_exam_unlocked(module_id: int) -> bool:
	var key := str(module_id)
	if not progress["modules"].has(key):
		return false
	return progress["modules"][key].get("exam_unlocked", false)

func unlock_exam(module_id: int) -> void:
	_ensure_module_key(module_id)
	var key := str(module_id)
	progress["modules"][key]["exam_unlocked"] = true
	save_progress()

func set_best_score(module_id: int, score: int) -> void:
	_ensure_module_key(module_id)
	var key := str(module_id)
	if score > progress["modules"][key].get("best_score", 0):
		progress["modules"][key]["best_score"] = score
		save_progress()

func get_best_score(module_id: int) -> int:
	var key := str(module_id)
	if not progress["modules"].has(key):
		return 0
	return progress["modules"][key].get("best_score", 0)

func get_module_progress(module_id: int) -> Dictionary:
	var key := str(module_id)
	return progress["modules"].get(key, {
		"lessons_completed": [],
		"best_score": 0,
		"exam_unlocked": false
	})

# --- Reset (para testing) ---
func reset_all() -> void:
	progress = {"unlocked_module": 1, "modules": {}}
	save_progress()
