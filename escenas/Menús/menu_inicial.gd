extends Control


@onready var animation_player: AnimationPlayer = $ColorRect3/AnimationPlayer
@onready var color_rect_3: ColorRect = $ColorRect3

func _ready():
	color_rect_3.visible = false  # Ocultar el rectángulo al iniciar el juego


func _on_jugar_pressed() -> void:
	GLOBAL.newGame()
	start_transition("res://escenas/Menús/seleccion del personje.tscn")
	

func _on_opciones_pressed() -> void:
	#get_tree().change_scene_to_file("res://escenas/Menús/menu_opciones.tscn")
	start_transition("res://escenas/Menús/menu_opciones.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()


func start_transition(nivel_path):
	color_rect_3.visible = true  # Hace visible el ColorRect antes de la animación
	animation_player.play("pasar")  # Reproduce la animación
	await animation_player.animation_finished  # Espera a que termine la animación
	get_tree().change_scene_to_file(nivel_path)  # Cambia de escena


func _on_continuar_pressed() -> void:
	GLOBAL.load_game()
	start_transition("res://escenas/Menús/seleccion del mapa.tscn")
