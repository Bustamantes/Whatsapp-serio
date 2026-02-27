extends Control
@onready var Version = $Version
@onready var M_salida = $"Menu salida"
@onready var M_creditos = $"Menu Creditos"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Version.text = "V "+ProjectSettings.get_setting("application/config/version") 		# muestra la version del juego


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_boton_prueba_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_screen.tscn")			#Cambia a la pantalla de juego


func _on_boton_creditos_pressed() -> void:			#lo que pasa si el boton de creditos es presionado
	M_creditos.show()			#muestra el menu de los creditos
	
func _on_regresar_creditos_pressed() -> void:
	M_creditos.hide()			#oculta el menu de creditos
	

func _on_boton_salida_pressed() -> void:			#lo que pasa si el boton de salida es presionado
	M_salida.show()			#muestra el menu de salida


func _on_salir_si_pressed() -> void:			#lo que pasa si opción "si" es presionada
	get_tree().quit()		#se sale del programa


func _on_salir_no_pressed() -> void:			#lo que pasa si opción "no" es presionada
	M_salida.hide()				#oculta el menu de salida
