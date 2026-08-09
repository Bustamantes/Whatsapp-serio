extends Node

const Save_File = "user://savefile.dat"		#es el lugar en donde se almacena los datos


# Variable que refleja en que nivel está el jugador
var Entered_level = 0

# Este archivo maneja la progresión de los niveles, puesto como una variable global, desbloqueando los niveles conforme se juega
var Level_finished = 0

# esta variable maneja la mejor puntuación alcanzada por el jugador
var Hi_score = 0
#var Music 
#var Sound 

var data = {}		#aqui almacena los datos persistenetes en el que se guardarán los datos

func _ready() -> void:
	load_data()		# al iniciar, intentará cargar los datos 

func save_data():
	var file = FileAccess.open(Save_File, FileAccess.WRITE)		#escribe datos al archivo
	#estos seran los datos que serán guardados
	data ={
		"Level_finished" = Level_finished,
		"Hi_score" = Hi_score,
		#"Music" = Music,
		#"Sound" = Sound,
	}
	file.store_var(data)		#almacena los datos en el archivo
	file = null		#vacia la variable para ser usada de nuevo
	
func load_data():
	#verifica si el archivo de datos existe
	if not FileAccess.file_exists(Save_File):
		#en caso de no existir, estos serán los datos por defecto
		data = {
			"Level_finished" = 0,
			"Hi_score" = 0,
			#"Music" = 0.5,
			#"Sound" = 0.5,
		}
		save_data()		#aqui hara el proceso de guardar los datos
		
	#en caso de que si haya datos guardados
	var file = FileAccess.open(Save_File,FileAccess.READ)		#busca el archivo de los datos
	data = file.get_var()		#carga los datos almacenados con anterioridad
	Level_finished = data.Level_finished		#en este caso, esta variable obtendrá el ultimo valor guardado
	Hi_score = data.Hi_score
	#Music = data.Music
	#Sound = data.Sound
	file = null
