extends Node

#Skin personajes
const personajes = [
	preload("res://imagenes/Personaje 2/outfit/playerRedIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerYellowIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerBlueIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerGreenIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerOrangeIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerPurpleIcon.png")
]

const personajes2 = [
	preload("res://imagenes/Personaje 2/outfit/playerRedIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerYellowIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerBlueIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerGreenIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerOrangeIcon.png"),
	preload("res://imagenes/Personaje 2/outfit/playerPurpleIcon.png")
]


#seleccion del personaje
var index_seleccion = 0
var index_seleccion2 = 1

#salir
var salir = false

#Juego completado
var JuegoCompletado = false
var fin = false

#niveles
var nivel1 = true
var nivel2 = false

#Jugador al completar el nivel
var nivel1_J1 = false
var nivel1_J2 = false

var nivel2_J1 = false
var nivel2_J2 = false

#Si esta jugando el jugagador
var JugandoJ1 = false
var JugandoJ2 = false

#Portales abiertos
var portal1Abierto = false
var portal2Abierto = false

#Diamentes Jugadores
var diamantes_J1 = 0
var diamantes_J2 = 0

#estrellas niveles
var estrellasN1 = 0
var estrellasN2 = 0

#nivel jugando
var JugandoNivel = 0

#tiempos
var tiempoN1J1:int
var tiempoN1J2:int
#var tiempoN1TOTAL

var tiempoN2J1:int
var tiempoN2J2:int
#var tiempoN2TOTAL

#Musica
var musica = true


var ruta: String = "res://save_game.save"

func save_game():
	var data: Dictionary = {
		index_seleccion = index_seleccion,
		index_seleccion2 = index_seleccion2,
		nivel1 = nivel1,
		nivel2 = nivel2,
		estrellasN1 = estrellasN1,
		estrellasN2 = estrellasN2,
		tiempoN1J1 = tiempoN1J1,
		tiempoN1J2 = tiempoN1J2,
		tiempoN2J1 = tiempoN2J1,
		tiempoN2J2 = tiempoN2J2,
		musica = musica
	}
	var file = FileAccess.open(ruta, FileAccess.WRITE)
	var data_json = JSON.stringify(data)
	
	file.store_line(data_json)
	print("Guardado exitoso")
	
func load_game():
	if not FileAccess.file_exists(ruta):
		print("No se encontró el archivo de guardado.")
		return

	var file = FileAccess.open(ruta, FileAccess.READ)
	if file:
		var line = file.get_line()
		var loaded_data = JSON.parse_string(line)  # En Godot 4 devuelve un diccionario directamente
		if typeof(loaded_data) != TYPE_DICTIONARY:
			print("Error al parsear JSON: El archivo no contiene un diccionario válido.")
			return

		# Actualiza las variables con los valores guardados
		index_seleccion  = loaded_data.get("index_seleccion", index_seleccion)
		index_seleccion2 = loaded_data.get("index_seleccion2", index_seleccion2)
		nivel1 = loaded_data.get("nivel1", nivel1)
		nivel2 = loaded_data.get("nivel2", nivel2)
		estrellasN1 = loaded_data.get("estrellasN1", estrellasN1)
		estrellasN2 = loaded_data.get("estrellasN2", estrellasN2)
		tiempoN1J1 = loaded_data.get("tiempoN1J1", tiempoN1J1)
		tiempoN1J2 = loaded_data.get("tiempoN1J2", tiempoN1J2)
		tiempoN2J1 = loaded_data.get("tiempoN2J1", tiempoN2J1)
		tiempoN2J2 = loaded_data.get("tiempoN2J2", tiempoN2J2)
		musica = loaded_data.get("musica", musica)

		print("Cargado exitoso")
		
		
func newGame():
	index_seleccion = 0
	index_seleccion2 = 1

	salir = false
	JuegoCompletado = false
	fin = false

	nivel1 = true
	nivel2 = false

	nivel1_J1 = false
	nivel1_J2 = false
	nivel2_J1 = false
	nivel2_J2 = false

	JugandoJ1 = false
	JugandoJ2 = false

	portal1Abierto = false
	portal2Abierto = false

	diamantes_J1 = 0
	diamantes_J2 = 0

	estrellasN1 = 0
	estrellasN2 = 0

	JugandoNivel = 0

	tiempoN1J1 = 0
	tiempoN1J2 = 0
	tiempoN2J1 = 0
	tiempoN2J2 = 0
