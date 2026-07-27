extends Control
@onready var TextPregunta = $"Espacio juego/Espacio preguntas/Pregunta"
@onready var Q1 = $"Espacio juego/Espacio preguntas/separador preguntas/pri caja/Seleccion 1"
@onready var Q2 = $"Espacio juego/Espacio preguntas/separador preguntas/seg caja/Seleccion 2"
@onready var Q3 = $"Espacio juego/Espacio preguntas/separador preguntas/pri caja/Seleccion 3"
@onready var Q4 = $"Espacio juego/Espacio preguntas/separador preguntas/seg caja/Seleccion 4"
@onready var Intenn = $"Espacio juego/Espacio preguntas/HBoxContainer/Caja intento/Intentos"
@onready var Puntto = $"Espacio juego/Espacio preguntas/HBoxContainer/Caja puntos/Puntos"
@onready var confii = $"Espacio juego/Espacio preguntas/Confirmacion"
@onready var mina = $AnimationPlayer
@onready var clik = $Click
@onready var Corec = $Correcto_Sonido
@onready var Incor = $Incorrecto_Sonido
@onready var M_fondo = $Musica_fondo

var intento = 3		#variable que muestra los intentos iniciales
var punto = 0		#variable utilizada para calcular el puntaje obtenido
var M_punto = 0		#variable usada de multiplicador del puntaje 
var Ultimo 	#variable usada para comparar con la opción correcta del archivo de las preguntas
var datos: Array 	
var glossa: Dictionary			
var tables: int = 0			#selecciona un grupo de la tabla de las preguntas del archivo de las preguntas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mina.play("Outfade")	#reproduce la animación de reaparecer
	match  LevelManager.Entered_level:
		1: datos = read_json_file("res://Levels/Questions_1.json")		#lee el archivo que contiene las preguntas de un nivel
		2: datos = read_json_file("res://Levels/Questions_2.json")
		3: datos = read_json_file("res://Levels/Questions_3.json")
		4: datos = read_json_file("res://Levels/Questions_4.json")
		5: datos = read_json_file("res://Levels/Questions_5.json")
		6: datos = read_json_file("res://Levels/Questions_6.json")
		_: $Felicita.show()		#en caso de error, va directo al menu principal
	if LevelManager.Level_finished >= LevelManager.Entered_level:		#las preguntas solo estaran en orden antes de pasar el nivel por primeras vez
		datos.shuffle()		#cambia el orden de las preguntas, pero una vez por partida, sin preguntas repetidas
	refresh_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func read_json_file(filename: String):
	var file = FileAccess.get_file_as_string(filename)	#accede al contenido del achivo selecionado
	var json_data = JSON.parse_string(file)				#convierte el contenido del array en tipo de datos "String"
	return json_data

func refresh_scene():
	#esta funcion verifica los estados(victoria, derrota o en juego) y transiciones del juego
	if tables >= datos.size() and intento > 0:		#en caso de completar el nivel de forma exitosa
		M_fondo.stop()
		$"Espacio juego/Espacio preguntas".hide()
		$Felicita.show()
		$"Felicita/Caja total/num total puntos".text = "{point}".format({"point":punto })
		if LevelManager.Level_finished < LevelManager.Entered_level:		#en caso de completar el nivel por primera vez, se irá desbloqueando el siguiente nivel en el menu principal
			LevelManager.Level_finished += 1
			
		LevelManager.Entered_level = 0
		
		if punto > LevelManager.Hi_score:	#verifica si la puntuación actual con la mejor puntuación
			LevelManager.Hi_score = punto
	elif intento == 0:	#en caso de que se agoten los intentos
		M_fondo.stop()
		$"Espacio juego/Espacio preguntas".hide()
		$Reniten.show()
	else:
		trivia_juego()
		
func trivia_juego():
	# esta es la funcion que contiene las bases del juego
	confii.disabled = true
	$NoTocar.hide()		#una imagen que evita al jugador de presionar los botones durante un proceso, se oculta para que el jugador pueda interactuar con el juego
	glossa= datos[tables]		#permite acceder al contenido del archivos de las preguntas
	TextPregunta.text = glossa.Question
	Q1.text = glossa.Choices[0]		#le cambia el texto anterior por una de las opciones de la tablas de las repuestas en el archivo de las preguntas
	Q2.text = glossa.Choices[1]
	Q3.text = glossa.Choices[2]
	Q4.text = glossa.Choices[3]
	match TranslationServer.get_locale():
		"es":Intenn.text = "Intentos: "
		"en":Intenn.text = "Tries: "	
	$"Espacio juego/Espacio preguntas/HBoxContainer/Caja intento/Num Intentos".text = "{try}".format({"try":intento })#aqui se muestran los intentos restantes
	$"Espacio juego/Espacio preguntas/HBoxContainer/Caja puntos/num puntos".text = "{point}".format({"point":punto })		#aqui se muestran los puntos obtenidos
	
	
func _on_seleccion_1_pressed() -> void:
	Ultimo = 0
	clik.play()
	confii.disabled = false

func _on_seleccion_2_pressed() -> void:
	Ultimo = 1
	clik.play()
	confii.disabled = false

func _on_seleccion_3_pressed() -> void:
	Ultimo = 2
	clik.play()
	confii.disabled = false

func _on_seleccion_4_pressed() -> void:
	Ultimo = 3
	clik.play()
	confii.disabled = false
	
func _on_confirmacion_pressed() -> void:
	confii.disabled = true
	$NoTocar.show()
	if Ultimo == glossa.Answer:
		Corec.play()
		match TranslationServer.get_locale():	#cambia el texto segun el idioma, pero sin guardar o sovreescribir esos datos
			"es":Intenn.text = "Correcto"
			"en":Intenn.text = "Correct"
		M_punto += 1		#el multiplicador aumenta por cada respuesta correcta
		punto += 100 * M_punto		#este es el calculo del puntaje
		await get_tree().create_timer(0.5).timeout 		# este comando crea una pausa temporal medida en segundos
	else:
		Incor.play()
		match TranslationServer.get_locale():
			"es":Intenn.text = "La respuesta es [" + glossa.Choices[glossa.Answer] + "]"
			"en":Intenn.text = "The answer is [" + glossa.Choices[glossa.Answer] + "]"
		intento -= 1
		M_punto = 0		#en caso de fallar una pregunta, el multiplicador se reinicia
		punto += 25		#se obtendrá menos puntos en caso de fallar
		if intento <= 0:
			intento = 0
		await get_tree().create_timer(1.5).timeout
	Q1.button_pressed = false
	Q2.button_pressed = false
	Q3.button_pressed = false
	Q4.button_pressed = false
	tables += 1
	refresh_scene()


func _on_reini_pressed() -> void:
	clik.play()
	mina.play("Infade")


func _on_salir_pressed() -> void:
	clik.play()
	mina.play("Infade")
	
	
func _on_volver_pressed() -> void:
	clik.play()
	mina.play("Infade")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Infade" and $Reniten/Reini.button_pressed:
		get_tree().reload_current_scene()
	
	if anim_name == "Infade" and ($Reniten/Salir.button_pressed or $Felicita/Volver.button_pressed):
		get_tree().change_scene_to_file("res://Scenes/control.tscn")
