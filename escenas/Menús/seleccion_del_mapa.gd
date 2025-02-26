extends CanvasLayer

@onready var personaje_1: CharacterBody2D = $Personaje1
@onready var personaje_2: CharacterBody2D = $Personaje2
@onready var nivel_1: Area2D = $Area2D
@onready var nivel_2: Area2D = $Area2D3
@onready var nivel_3: Area2D = $Area2D2
@onready var fade_rect: ColorRect = $FadeRect
@onready var pantalla: ColorRect = $pantalla
@onready var animation_player: AnimationPlayer = $pantalla/AnimationPlayer
@onready var btn_nivel_1: Button = $Panel/HBoxContainer/btnNivel1
@onready var btn_nivel_2: Button = $Panel/HBoxContainer/btnNivel2

@onready var star_n_1: AnimatedSprite2D = $Panel/HBoxContainer/btnNivel1/starN1
@onready var star_n_2: AnimatedSprite2D = $Panel/HBoxContainer/btnNivel2/starN2
@onready var bloqueado: AnimatedSprite2D = $Panel/HBoxContainer/btnNivel2/bloqueado
@onready var label_1: Label = $Panel/HBoxContainer/btnNivel1/Label1
@onready var label_2: Label = $Panel/HBoxContainer/btnNivel2/Label2

@onready var pergamino: Node2D = $Pergamino
@onready var ganador: Label = $Pergamino/ganador
@onready var puntuacion_1: Label = $Pergamino/puntuacion1
@onready var puntuacion_2: Label = $Pergamino/puntuacion2

@onready var pergamino_menu: Node2D = $pergaminoMenu
@onready var musica_off: Button = $pergaminoMenu/musicaOff
@onready var musica_on: Button = $pergaminoMenu/musicaOn



var nivel1 = GLOBAL.nivel1
var nivel2 = GLOBAL.nivel2
var enMenu = false

func _ready() -> void:
	pantalla.visible = false
	pergamino_menu.visible = false
	verificar_nivel()
	actualizarEstrellasNiveles()
	GLOBAL.JugandoNivel = 0
	if not enMenu:
		nivel_1.body_entered.connect(_on_nivel_entered.bind("res://escenas/Mapa 1/mapa_1.tscn"))
		nivel_2.body_entered.connect(_on_nivel_entered.bind("res://escenas/Mapa 2/mapa_2.tscn"))
	
	if GLOBAL.JuegoCompletado and not GLOBAL.fin:
		calcularDatosImprimir()
		pergamino.visible = true
	else:
		pergamino.visible = false
	actualizarMusica()
	
func calcularDatosImprimir():
	var puntuacionGJ1 = 0
	var puntuacionGJ2 = 0
	puntuacionGJ1 += GLOBAL.tiempoN1J1
	puntuacionGJ1 += GLOBAL.tiempoN2J1
	
	puntuacionGJ2 += GLOBAL.tiempoN1J2
	puntuacionGJ2 += GLOBAL.tiempoN2J2
	
	if puntuacionGJ1 > puntuacionGJ2:
		ganador.text = "Ganador: Jugador 2"
	else:
		ganador.text = "Ganador: Jugador 1"
	
	puntuacion_1.text = "Puntuacion J1: " + str(puntuacionGJ1)
	puntuacion_2.text = "Puntuacion J2: " + str(puntuacionGJ2)

	
func actualizarEstrellasNiveles():
	star_n_1.play(str(GLOBAL.estrellasN1))
	if nivel2:
		star_n_2.play(str(GLOBAL.estrellasN2))

func verificar_nivel():
	nivel_1.set_monitoring(true)  # Nivel 1 siempre activo
	
	if nivel2:
		nivel_2.set_monitoring(true)
		bloqueado.visible = false
		star_n_2.visible = true
		label_2.visible = true
	else:
		nivel_2.set_monitoring(false)  # Solo activar/desactivar nivel 2 según su estado
		bloqueado.visible = true
		star_n_2.visible = false
		label_2.visible = false
		
func _on_nivel_entered(body, nivel_path):
	if body == personaje_2 or body == personaje_1:
		start_transition(nivel_path)

func start_transition(nivel_path):
	pantalla.visible = true
	animation_player.play("transicion")  # Reproduce la animación
	await animation_player.animation_finished  # Espera a que termine la animación
	get_tree().change_scene_to_file(nivel_path)  # Cawmbia de escena


func _on_btn_nivel_1_pressed() -> void:
	start_transition("res://escenas/Mapa 1/mapa_1.tscn")


func _on_btn_nivel_2_pressed() -> void:
	if GLOBAL.nivel2:
		start_transition("res://escenas/Mapa 2/mapa_2.tscn")


func _on_continuar_pressed() -> void:
	pergamino.visible = false
	GLOBAL.fin = true



func _on_musica_off_pressed() -> void:
	GLOBAL.musica = false
	actualizarMusica()


func _on_musica_on_pressed() -> void:
	GLOBAL.musica = true
	actualizarMusica()


func _on_guardar_pressed() -> void:
	GLOBAL.save_game()


func _on_menu_pressed() -> void:
	if pergamino_menu.visible:
		actualizarMusica()
		pergamino_menu.visible = false
		enMenu = false
	else:
		pergamino_menu.visible = true
		enMenu = true
func actualizarMusica():
	if GLOBAL.musica:
		musica_on.visible = false
		musica_off.visible = true
		Musica.reanudarMusica()
	else:
		musica_off.visible = false
		musica_on.visible = true
		Musica.pausarMusica()


func _on_casa_pressed() -> void:
	
	start_transition("res://escenas/Menús/menu_inicial.tscn")
