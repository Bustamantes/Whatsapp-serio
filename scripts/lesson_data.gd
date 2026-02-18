extends Node

# Datos de todas las lecciones

static func obtener_pasos(lesson_id: String) -> Array:
	match lesson_id:
		"enviar_mensaje":
			return [
				{
					"instruccion": "¿Dónde tocas para escribir un mensaje nuevo?",
					"opciones": [
						{"texto": "En el ícono de cámara", "correcta": false},
						{"texto": "En el ícono de mensaje (💬) abajo a la derecha", "correcta": true},
						{"texto": "En la barra de búsqueda", "correcta": false},
					]
				},
				{
					"instruccion": "¿Cómo seleccionas a quién enviar el mensaje?",
					"opciones": [
						{"texto": "Buscas su nombre en la lista de contactos", "correcta": true},
						{"texto": "Escribes su número en la barra de mensajes", "correcta": false},
						{"texto": "Sacudes el teléfono", "correcta": false},
					]
				},
				{
					"instruccion": "¿Dónde escribes tu mensaje?",
					"opciones": [
						{"texto": "En la parte de arriba de la pantalla", "correcta": false},
						{"texto": "En la barra que dice 'Mensaje' abajo", "correcta": true},
						{"texto": "En el nombre del contacto", "correcta": false},
					]
				},
				{
					"instruccion": "¿Cómo envías el mensaje?",
					"opciones": [
						{"texto": "Tocas el botón verde con la flecha ➤", "correcta": true},
						{"texto": "Cierras WhatsApp", "correcta": false},
						{"texto": "Esperas 10 segundos", "correcta": false},
					]
				},
			]
		"hacer_llamada":
			return [
				{
					"instruccion": "¿Dónde encuentras la opción de llamar?",
					"opciones": [
						{"texto": "En la pestaña 'Llamadas' arriba", "correcta": true},
						{"texto": "En las configuraciones", "correcta": false},
						{"texto": "En los estados", "correcta": false},
					]
				},
				{
					"instruccion": "¿Qué ícono tocas para llamar a alguien?",
					"opciones": [
						{"texto": "El ícono de mensaje", "correcta": false},
						{"texto": "El ícono de teléfono 📞", "correcta": true},
						{"texto": "El ícono de cámara", "correcta": false},
					]
				},
				{
					"instruccion": "¿Cómo terminas una llamada?",
					"opciones": [
						{"texto": "Tocas el botón rojo 🔴", "correcta": true},
						{"texto": "Apagas el teléfono", "correcta": false},
						{"texto": "Esperas que la otra persona cuelgue", "correcta": false},
					]
				},
			]
		"enviar_foto":
			return [
				{
					"instruccion": "¿Dónde tocas para enviar una foto?",
					"opciones": [
						{"texto": "En el ícono de clip 📎 o cámara 📷", "correcta": true},
						{"texto": "En el nombre del contacto", "correcta": false},
						{"texto": "En la barra de búsqueda", "correcta": false},
					]
				},
				{
					"instruccion": "¿De dónde puedes elegir la foto?",
					"opciones": [
						{"texto": "Solo de internet", "correcta": false},
						{"texto": "De la galería o tomar una nueva", "correcta": true},
						{"texto": "Solo fotos nuevas", "correcta": false},
					]
				},
			]
		"crear_grupo":
			return [
				{
					"instruccion": "¿Cómo creas un grupo nuevo?",
					"opciones": [
						{"texto": "Tocas los 3 puntos ⋮ → 'Nuevo grupo'", "correcta": true},
						{"texto": "Llamas a varias personas al mismo tiempo", "correcta": false},
						{"texto": "Envías un mensaje a todos tus contactos", "correcta": false},
					]
				},
				{
					"instruccion": "¿Qué necesitas hacer después de seleccionar los miembros?",
					"opciones": [
						{"texto": "Ponerle un nombre al grupo", "correcta": true},
						{"texto": "Llamar a cada miembro", "correcta": false},
						{"texto": "Enviar tu ubicación", "correcta": false},
					]
				},
			]
		"enviar_audio":
			return [
				{
					"instruccion": "¿Cómo grabas un mensaje de voz?",
					"opciones": [
						{"texto": "Mantienes presionado el ícono de micrófono 🎤", "correcta": true},
						{"texto": "Tocas el ícono de clip", "correcta": false},
						{"texto": "Escribes 'audio' en el chat", "correcta": false},
					]
				},
				{
					"instruccion": "¿Cómo envías el audio?",
					"opciones": [
						{"texto": "Sueltas el botón del micrófono", "correcta": true},
						{"texto": "Tocas el botón de llamar", "correcta": false},
						{"texto": "Cierras la conversación", "correcta": false},
					]
				},
			]
		"estados":
			return [
				{
					"instruccion": "¿Dónde ves los estados de tus contactos?",
					"opciones": [
						{"texto": "En la pestaña 'Estados' o 'Novedades'", "correcta": true},
						{"texto": "En la lista de chats", "correcta": false},
						{"texto": "En las configuraciones", "correcta": false},
					]
				},
				{
					"instruccion": "¿Cómo publicas tu propio estado?",
					"opciones": [
						{"texto": "Tocas 'Mi estado' y luego el ícono de cámara o lápiz", "correcta": true},
						{"texto": "Envías un mensaje a todos tus contactos", "correcta": false},
						{"texto": "Cambias tu foto de perfil", "correcta": false},
					]
				},
			]
	return []
