extends Control
@onready var Version = $"Menu Creditos/Version"
@onready var M_salida = $"Menu salida"
@onready var M_creditos = $"Menu Creditos"
@onready var N_uno = $"VFlowContainer/Borde boton/Boton prueba"		#estas variable son los botones de los niveles
@onready var N_dos = $"VFlowContainer/Borde boton2/Boton prueba2"
@onready var N_tres = $"VFlowContainer/Borde boton3/Boton prueba3"
@onready var N_cuatro = $"VFlowContainer/Borde boton4/Boton prueba4"
@onready var N_cinco = $"VFlowContainer/Borde boton5/Boton prueba5"
@onready var N_seis = $"VFlowContainer/Borde boton6/Boton prueba6"
@onready var Anim = $AnimationPlayer	#esta variable permite utilizar animaciones
@onready var Adio = $Click_sonido		#esta variable es para utilizar sonidos
@onready var Music_vol = $"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/VBoxContainer/HMusica/Mvolume"		#estas variables son las barras de volume
@onready var SFX_vol = $"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/VBoxContainer/HSonido/Svolume"

func _ready() -> void:
	$M_menu.bus = "Music"		#asigna un sonido a un bus de audio
	$Click_sonido.bus = "SFX"
	LevelManager.save_data() #llama a la funcion de guardar datos
	Anim.play("Outfade")		#reproduce la animación de reaparecer
	Version.text = "v"+ProjectSettings.get_setting("application/config/version") 		# muestra la version del juego
	
	# Verifica el progreso de los niveles
	if LevelManager.Level_finished >= 1:
		N_dos.disabled = false		
	else:
		N_dos.disabled = true
		N_dos.text = "???"		# en caso de que el boton esté bloqueado, se ocultará el texto con sigos de interrogación
		
	if LevelManager.Level_finished >= 2:
		N_tres.disabled = false
	else:
		N_tres.disabled = true
		N_tres.text = "???"
		
	if LevelManager.Level_finished >= 3:
		N_cuatro.disabled = false
	else:
		N_cuatro.disabled = true
		N_cuatro.text = "???"
		
	if LevelManager.Level_finished >= 4:
		N_cinco.disabled = false
	else:
		N_cinco.disabled = true
		N_cinco.text = "???"
		
	if LevelManager.Level_finished >= 5:
		N_seis.disabled = false
	else:
		N_seis.disabled = true
		N_seis.text = "???"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_boton_prueba_pressed() -> void:
	LevelManager.Entered_level = 1
	Adio.play()		#reproduce un sonido
	Anim.play("Infade")		#reproduce la animación de desvanecer

func _on_boton_prueba_2_pressed() -> void:
	LevelManager.Entered_level = 2
	Adio.play()
	Anim.play("Infade")

func _on_boton_prueba_3_pressed() -> void:
	LevelManager.Entered_level = 3
	Adio.play()
	Anim.play("Infade")
	
func _on_boton_prueba_4_pressed() -> void:
	LevelManager.Entered_level = 4
	Adio.play()
	Anim.play("Infade")
	
func _on_boton_prueba_5_pressed() -> void:
	LevelManager.Entered_level = 5
	Adio.play()
	Anim.play("Infade")

func _on_boton_prueba_6_pressed() -> void:
	LevelManager.Entered_level = 6
	Adio.play()
	Anim.play("Infade")
	
func _on_boton_opciones_pressed() -> void:
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones".show()
	$"Barra Inferior/HBoxContainer/Boton opciones".disabled = true		#desabilita el uso del boton
	$"Barra Inferior/HBoxContainer/Boton salida".disabled = true
	$Nontouch.show()
	Adio.play()
	
func _on_regresar_opciones_pressed() -> void:
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones".hide()
	$"Barra Inferior/HBoxContainer/Boton opciones".disabled = false		#reactiva el uso del boton
	$"Barra Inferior/HBoxContainer/Boton salida".disabled = false
	$Nontouch.hide()
	Adio.play()
	
func _on_boton_reinicio_pressed() -> void:
	OS.move_to_trash(ProjectSettings.globalize_path("user://savefile.dat"))		#este comando mueve el archivo de guardado a la papelera
	LevelManager.Level_finished = 0
	Adio.play()
	get_tree().reload_current_scene()
	
func _on_boton_creditos_pressed() -> void:			#lo que pasa si el boton de creditos es presionado
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton creditos".disabled = true
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton reinicio".disabled = true
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Regresar opciones".disabled = true
	Adio.play()
	M_creditos.show()			#muestra el menu de los creditos
	
func _on_regresar_creditos_pressed() -> void:
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton creditos".disabled = false
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton reinicio".disabled = false
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Regresar opciones".disabled = false
	Adio.play()
	M_creditos.hide()			#oculta el menu de creditos
	
func _on_boton_salida_pressed() -> void:			#lo que pasa si el boton de salida es presionado
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton creditos".disabled = true
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton reinicio".disabled = true
	$"Barra Inferior/HBoxContainer/Boton opciones".disabled = true
	$"Barra Inferior/HBoxContainer/Boton salida".disabled = true
	Adio.play()
	$Nontouch.show()
	M_salida.show()			#muestra el menu de salida

func _on_salir_si_pressed() -> void:			#lo que pasa si opción "si" es presionada
	get_tree().quit()		#se sale del programa

func _on_salir_no_pressed() -> void:			#lo que pasa si opción "no" es presionada
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton creditos".disabled = false
	$"Barra Inferior/HBoxContainer/Boton opciones/Menu opciones/HBotones/Boton reinicio".disabled = false
	$"Barra Inferior/HBoxContainer/Boton opciones".disabled = false
	$"Barra Inferior/HBoxContainer/Boton salida".disabled = false
	Adio.play()
	$Nontouch.hide()
	M_salida.hide()				#oculta el menu de salida


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Infade":		#verifica que solo cambie de escena si se usa una animación especifica
		get_tree().change_scene_to_file("res://Scenes/game_screen.tscn")			#Cambia a la pantalla de juego
	

func _on_mvolume_value_changed(value: float) -> void:
	Adio.play()
	AudioServer.set_bus_volume_db(1,linear_to_db(Music_vol.value))		#ajusta el volumen del bus de audio segun la barra de opciones
	print("Music: " ,Music_vol.value)

func _on_svolume_value_changed(value: float) -> void:
	Adio.play()
	AudioServer.set_bus_volume_db(2,linear_to_db(SFX_vol.value))
	print("SFX: " , SFX_vol.value)
