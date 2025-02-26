extends Control

@onready var musica_off: Button = $musicaOff
@onready var musica_on: Button = $musicaOn
@onready var color_rect_4: ColorRect = $ColorRect4
@onready var animation_player: AnimationPlayer = $ColorRect4/AnimationPlayer
@onready var controles: Node2D = $Controles



func _ready() -> void:
	actualizarMusica()
	controles.visible = false
	pass
#
func _on_volver_pressed() -> void:
	start_transition("res://escenas/Menús/menu_inicial.tscn")
	

func _on_musica_off_pressed() -> void:
	GLOBAL.musica = false
	actualizarMusica()

func _on_musica_on_pressed() -> void:
	GLOBAL.musica = true
	actualizarMusica()
	
func actualizarMusica():
	if GLOBAL.musica:
		musica_on.visible = false
		musica_off.visible = true
		Musica.reanudarMusica()
	else:
		musica_off.visible = false
		musica_on.visible = true
		Musica.pausarMusica()

func start_transition(nivel_path):
	color_rect_4.visible = true  # Hace visible el ColorRect antes de la animación
	animation_player.play("pasar")  # Reproduce la animación
	await animation_player.animation_finished  # Espera a que termine la animación
	get_tree().change_scene_to_file(nivel_path)  # Cambia de escena


func _on_continuar_pressed() -> void:
	controles.visible = false


func _on_controles_pressed() -> void:
	controles.visible = true
