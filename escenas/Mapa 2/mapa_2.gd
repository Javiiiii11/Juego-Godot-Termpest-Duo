extends Node2D

@onready var portal_1: Area2D = $portal_J1/Portal1Area2d
@onready var portal_2: Area2D = $portal_J2/Portal2Area2d
@onready var portal_j_1: Node2D = $portal_J1/AnimatedSprite2D
@onready var portal_j_2: Node2D = $portal_J2/AnimatedSprite2D



@onready var personaje_1: CharacterBody2D = $Personaje1
@onready var personaje_2: CharacterBody2D = $Personaje2
@onready var pantalla: ColorRect = $pantalla
@onready var animation_player: AnimationPlayer = $Personaje1/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $Personaje2/AnimationPlayer
@onready var pantalla_animation_player: AnimationPlayer = $pantalla/AnimationPlayer
@onready var label_1: Label = $Label
@onready var label_2: Label = $Label2

@onready var pergamino: Node2D = $Pergamino
@onready var estrellas: AnimatedSprite2D = $Pergamino/estrellas
@onready var ganador: Label = $Pergamino/ganador
@onready var puntuacion_0: Label = $Pergamino/puntuacion0
@onready var puntuacion_1: Label = $Pergamino/puntuacion1
@onready var puntuacion_2: Label = $Pergamino/puntuacion2
@onready var continuar: Button = $Pergamino/continuar

@onready var pergamino_menu: Node2D = $pergaminoMenu
@onready var cargando: AnimatedSprite2D = $cargando


var J1_dentro: bool = false
var J2_dentro: bool = false
var next_scene_path: String = ""  # Variable para almacenar la próxima escena
var tiempo1_corriendo: bool = false
var tiempo2_corriendo: bool = false
var tiempo1: int = 0
var tiempo2: int = 0
var pergaminoMostrado: bool = false

func _ready():
	Musica.saved_index = 1
	Musica._ready()
	pergamino.visible = false
	cargando.visible = false
	portal_1.connect("body_entered", _on_portal_1_entered)
	portal_2.connect("body_entered", _on_portal_2_entered)
	GLOBAL.JugandoNivel = 2

	GLOBAL.nivel2_J1 = false
	GLOBAL.nivel2_J2 = false
	J1_dentro = GLOBAL.nivel2_J1
	J2_dentro = GLOBAL.nivel2_J2
	pantalla.visible = false
	tiempo1_corriendo = true
	tiempo2_corriendo = true
	
	# Recuperar el tiempo guardado antes de iniciar el conteo
	tiempo1 = GLOBAL.tiempoN2J1
	tiempo2 = GLOBAL.tiempoN2J2
	
	pantalla_animation_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	label_1.text = "Jugador 1: " + str(tiempo1)
	label_2.text = "Jugador 2: " + str(tiempo2)
	if tiempo1_corriendo:
		tiempo1 += 1
	if tiempo2_corriendo:
		tiempo2 += 1
	
	await get_tree().create_timer(1.0).timeout

	if J1_dentro and J2_dentro and not pergaminoMostrado:
		await get_tree().create_timer(1.0).timeout
		pergaminoMostrado = true  # Se marca para que no se vuelva a ejecutar
		GLOBAL.JuegoCompletado = true
		print("¡Ambos jugadores dentro! Mostrando pergamino.")
		print("Juego completado")
		mostrar_pergamino()
	
	if GLOBAL.salir:
		start_transition("res://escenas/Menús/seleccion del mapa.tscn")
		GLOBAL.salir = false

func _on_portal_1_entered(body):
	if body == personaje_1 and GLOBAL.portal1Abierto:
		print("Personaje 1 ha entrado en Portal 1")
		GLOBAL.tiempoN2J1 = tiempo1  # Guardar el tiempo antes de detenerlo
		tiempo1_corriendo = false
		J1_dentro = true
		teletransportar_personaje(personaje_1, portal_1)		
		await get_tree().create_timer(1).timeout
		# Cerrar portal 1
		portal_j_1.play(str(GLOBAL.index_seleccion) + "cerrar")
		portal_1.set_deferred("monitoring", false) # Desactivar detección de colisiones
		GLOBAL.portal1Abierto = false
		#Ocultar jugador
		await get_tree().create_timer(0.5).timeout
		personaje_1.visible = false

func _on_portal_2_entered(body):
	if body == personaje_2 and GLOBAL.portal2Abierto:
		print("Personaje 2 ha entrado en Portal 2")
		GLOBAL.tiempoN2J2 = tiempo2  # Guardar el tiempo antes de detenerlo
		tiempo2_corriendo = false
		J2_dentro = true
		teletransportar_personaje(personaje_2, portal_2)
		await get_tree().create_timer(1).timeout
		# Cerrar portal 2
		portal_j_2.play(str(GLOBAL.index_seleccion2) + "cerrar")
		GLOBAL.portal2Abierto = false
		#Ocultar jugador
		await get_tree().create_timer(0.5).timeout
		personaje_2.visible = false

func teletransportar_personaje(personaje: CharacterBody2D, portal: Area2D): 
	var portal_center = portal.get_parent().global_position 
	var anim_player = animation_player if personaje == personaje_1 else animation_player2
	anim_player.play("portal")
	var tween = get_tree().create_tween() 
	tween.tween_property(personaje, "global_position", portal_center, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func start_transition(nivel_path: String):
	next_scene_path = nivel_path  
	pantalla.visible = true  
	pantalla_animation_player.play("pasar")

func _on_animation_finished(anim_name: String):
	if anim_name == "pasar" and next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
		pantalla.visible = false

func mostrar_pergamino() -> void:
	pantalla.visible = true
	cargando.visible = true
	pantalla_animation_player.play("pasar")
	cargando.play("cargando1")
	await get_tree().create_timer(1.0).timeout
	print("yo")
	pergamino.visible = true
	pergaminoInicio()

func pergaminoInicio():
	comprobarDatos()
	var Jganador = comprobarGanador()
	imprimirDatos(Jganador, tiempo1, tiempo2)

func comprobarDatos():
	if tiempo1 == GLOBAL.tiempoN2J1:
		print("tiempo bien")
	if tiempo2 == GLOBAL.tiempoN2J2:
		print("tiempo bien")

func comprobarGanador() -> int:
	if tiempo1 < tiempo2:
		print("Jugador 1 gana con un tiempo de", tiempo1)
		return 1
	elif tiempo2 < tiempo1:
		print("Jugador 2 gana con un tiempo de", tiempo2)
		return 2
	else:
		print("Error")
		return 0

func imprimirDatos(Jganador: int, tiempoJ1: int, tiempoJ2: int):
	if Jganador == 1:
		ganador.text = "Ganador: Jugador 1"
	elif Jganador == 2:
		ganador.text = "Ganador: Jugador 2"
	var tiempo0 = tiempo1 + tiempo2 
	puntuacion_0.text = "Puntuación: " + str(tiempo0)
	puntuacion_1.text = "Puntuación J1: " + str(tiempoJ1)
	puntuacion_2.text = "Puntuación J2: " + str(tiempoJ2)
	
	var nuevas_estrellas = 0
	if tiempo0 < 18000:
		estrellas.play("3")
		nuevas_estrellas = 3
	elif tiempo0 > 18000 and tiempo0 < 24000:
		estrellas.play("2")
		nuevas_estrellas = 2
	elif tiempo0 > 24000:
		estrellas.play("1")
		nuevas_estrellas = 1

	# Solo actualizar si el nuevo valor es mayor
	if nuevas_estrellas > GLOBAL.estrellasN2:
		GLOBAL.estrellasN2 = nuevas_estrellas


func _input(event):
	if Input.is_action_pressed("Menu"):
		get_tree().paused = true  # Pausa todo el juego
		pergamino_menu.visible = true
		

func _on_continuar_pressed() -> void:
	GLOBAL.diamantes_J1 = 0
	GLOBAL.diamantes_J2 = 0
	GLOBAL.portal1Abierto = false
	GLOBAL.portal2Abierto = false
	print("nivel terminado")
	Musica.saved_index = 0
	Musica._ready()
	get_tree().change_scene_to_file("res://escenas/Menús/seleccion del mapa.tscn")
