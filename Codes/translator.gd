extends Node
#se ha creado una archivo que contiene las variables traducibles en los idiomas deseables(en este caso español e íngles)
var group_grabber		#se agrupan los nodos traducibles en un grupo
var key		#se le agrega un variable metadato para usar las variables del archivo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TranslationServer.set_locale("en") #esto simula el idioma seleccionado segun el codigo regional (para propositos de prueba)
	Translating_text()		#funcion para traducir los textos segun el archivo de traduccion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Translating_text():
	group_grabber = get_tree().get_nodes_in_group("Multidioma")		#aqui selecciona los nodos que estan en el grupo de los textos traducibles
	for Node in group_grabber:
		key = Node.get_meta("keys")		#aqui conecta las variables de los metadatos con las variables de las traducciones
		Node.text = tr(key)		#aqui coloca el texto asociado a una variable de traduccion a uno de los idiomas disponibles
