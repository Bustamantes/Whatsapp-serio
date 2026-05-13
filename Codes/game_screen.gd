extends Control
@onready var TextPregunta = $"Espacio juego/Espacio preguntas/Pregunta"
@onready var Q1 = $"Espacio juego/Espacio preguntas/separador preguntas/pri caja/Seleccion 1"
@onready var Q2 = $"Espacio juego/Espacio preguntas/separador preguntas/seg caja/Seleccion 2"
@onready var Q3 = $"Espacio juego/Espacio preguntas/separador preguntas/pri caja/Seleccion 3"
@onready var Q4 = $"Espacio juego/Espacio preguntas/separador preguntas/seg caja/Seleccion 4"
@onready var Intenn = $"Espacio juego/Espacio preguntas/Intentos"
@onready var confii = $"Espacio juego/Espacio preguntas/Confirmacion"

var intentos = 3
var Ultimo 	#variable usada para comparar con la opción correcta del archivo de las preguntas
var datos: Array 	
var glossa: Dictionary			
var tables: int = 0			#selecciona un grupo de la tabla de las preguntas del archivo de las preguntas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match  LevelManager.Entered_level:
		1: datos = read_json_file("res://Levels/Questions_1.json")		#lee el archivo que contiene las preguntas de un nivel
		2: datos = read_json_file("res://Levels/Questions_2.json")
		3: datos = read_json_file("res://Levels/Questions_3.json")
		4: datos = read_json_file("res://Levels/Questions_4.json")
		5: datos = read_json_file("res://Levels/Questions_5.json")
		6: datos = read_json_file("res://Levels/Questions_6.json")
		_: get_tree().change_scene_to_file("res://Scenes/control.tscn")	#en caso de error, va directo al menu principal
	refresh_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func read_json_file(filename: String):
	var file = FileAccess.get_file_as_string(filename)	#accede al contenido del achivo selecionado
	var json_data = JSON.parse_string(file)				#convierte el contenido del array en tipo de datos "String"
	return json_data

func refresh_scene():
	if tables >= datos.size() and intentos > 0:		#en caso de completar el nivel de forma exitosa
		get_tree().change_scene_to_file("res://Scenes/control.tscn")
		if LevelManager.Level_finished < LevelManager.Entered_level:		#en caso de completar el nivel por primera vez, desbloqueando el siguiente nivel
			LevelManager.Level_finished += 1
		LevelManager.Entered_level = 0		
	elif tables >= datos.size() and intentos <= 0:	#muestra las preguntas si hay rondas de preguntas disponibles ,en este caso, items.size() significa todos los elementos del objeto en caso de querer usar todo el contenido del array
		get_tree().change_scene_to_file("res://Scenes/control.tscn")
	else:
		trivia_juego()
		
func trivia_juego():
	confii.disabled = true
	glossa= datos[tables]		#permite acceder al contenido del archivos de las preguntas
	TextPregunta.text = glossa.Question
	Q1.text = glossa.Choices[0]		#le cambia el texto anterior por una de las respuestas de la tablas de las repuestas en el archivo de las preguntas
	Q2.text = glossa.Choices[1]
	Q3.text = glossa.Choices[2]
	Q4.text = glossa.Choices[3]
	Intenn.text = "Intentos: {intentos}".format({"intentos": intentos})
	
func _on_seleccion_1_pressed() -> void:
	Ultimo = 0		
	confii.disabled = false

func _on_seleccion_2_pressed() -> void:
	Ultimo = 1
	confii.disabled = false

func _on_seleccion_3_pressed() -> void:
	Ultimo = 2
	confii.disabled = false

func _on_seleccion_4_pressed() -> void:
	Ultimo = 3
	confii.disabled = false
	
func _on_confirmacion_pressed() -> void:
	confii.disabled = true
	if Ultimo == glossa.Answer:
		Intenn.text = "Correcto"
		await get_tree().create_timer(1).timeout
	else :
		Intenn.text = "La respuesta es [" + glossa.Choices[glossa.Answer] + "]"
		intentos -= 1
		if intentos <= 0:
			intentos = 0
		await get_tree().create_timer(2).timeout
	Q1.button_pressed = false
	Q2.button_pressed = false
	Q3.button_pressed = false
	Q4.button_pressed = false
	tables += 1
	refresh_scene()
