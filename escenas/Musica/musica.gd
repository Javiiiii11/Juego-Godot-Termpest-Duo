extends Node
class_name GlobalMusic

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
var saved_index: int = 0

func _ready():
	music_player.connect("finished", Callable(self, "_on_music_finished"))

	# Cargar la configuración guardada (opcional)
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		saved_index = config.get_value("Audio", "selected_music", 0)
	
	# Diccionario de canciones (debe coincidir con el usado en la interfaz)
	var music_list = {
		"inicio": "res://musica/inicio1.mp3",
		"nivel" : "res://musica/nivel.mp3"
	}
	
	var keys = music_list.keys()
	# Se asume que GLOBAL.musica es una variable global que determina si se activa la música
	if GLOBAL.musica:
		if saved_index >= 0 and saved_index < keys.size():
			var song_name = keys[saved_index]
			var song_path = music_list[song_name]
			cambiarCancion(song_path)
		else:
			# Si el índice es inválido, reproducir la primera canción
			cambiarCancion(music_list[keys[0]])

func cambiarCancion(cancion_path: String):
	# Detener la canción actual si se está reproduciendo
	if music_player.playing:
		music_player.stop()
	
	# Cargar el AudioStream desde la ruta
	var music_stream = load(cancion_path) as AudioStream
	if music_stream:
		music_player.stream = music_stream
		music_player.play()
	else:
		print("Error: No se pudo cargar la canción: ", cancion_path)

# Método para pausar la música
func pausarMusica():
	# Si se está reproduciendo y no está ya en pausa, se pausa
	if music_player.playing and not music_player.stream_paused:
		music_player.stream_paused = true

# Método para reanudar la música
func reanudarMusica():
	# Si la música está en pausa, se reanuda
	if music_player.stream_paused:
		music_player.stream_paused = false

# Método para reiniciar la música cuando termine
func _on_music_finished():
	music_player.play()
	
