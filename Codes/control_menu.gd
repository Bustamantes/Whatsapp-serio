extends Control
@onready var Version = $Version
@onready var M_salida = $"Menu salida"
@onready var M_creditos = $"Menu Creditos"
@onready var N_uno = $"Borde boton/Boton prueba"
@onready var N_dos = $"Borde boton2/Boton prueba2"


func _ready() -> void:
	Version.text = "v"+ProjectSettings.get_setting("application/config/version") 		# muestra la version del juego
	# Verifica el progreso de los niveles
	if LevelManager.Level_finished >= 1:
		N_dos.disabled = false
		
	if LevelManager.Level_finished >= 2:
		pass	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_boton_prueba_pressed() -> void:
	LevelManager.Entered_level = 1
	get_tree().change_scene_to_file("res://Scenes/game_screen.tscn")			#Cambia a la pantalla de juego

func _on_boton_prueba_2_pressed() -> void:
	LevelManager.Entered_level = 2
	get_tree().change_scene_to_file("res://Scenes/game_screen.tscn")
	
func _on_boton_creditos_pressed() -> void:			#lo que pasa si el boton de creditos es presionado
	M_creditos.show()			#muestra el menu de los creditos
	
func _on_regresar_creditos_pressed() -> void:
	M_creditos.hide()			#oculta el menu de creditos
	

func _on_boton_salida_pressed() -> void:			#lo que pasa si el boton de salida es presionado
	LevelManager.save_data()		#llama a la funcion de guardar datos
	M_salida.show()			#muestra el menu de salida


func _on_salir_si_pressed() -> void:			#lo que pasa si opción "si" es presionada
	get_tree().quit()		#se sale del programa

func _on_salir_no_pressed() -> void:			#lo que pasa si opción "no" es presionada
	M_salida.hide()				#oculta el menu de salida
