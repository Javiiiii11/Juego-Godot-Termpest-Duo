extends CanvasLayer

@onready var char_portrait: Sprite2D = $Sprite2D
@onready var char_portrait2: Sprite2D = $Sprite2D2
@onready var color_rect_3: ColorRect = $ColorRect3
@onready var animation_player: AnimationPlayer = $ColorRect3/AnimationPlayer

func _ready() -> void:
	update_portrait1(GLOBAL.index_seleccion)
	update_portrait2(GLOBAL.index_seleccion2)

func update_portrait1(index):
	char_portrait.texture = GLOBAL.personajes[index]

func update_portrait2(index):
	char_portrait2.texture = GLOBAL.personajes2[index]

func _on_dere_1_pressed() -> void:
	var prev_index = GLOBAL.index_seleccion
	GLOBAL.index_seleccion = (GLOBAL.index_seleccion + 1) % GLOBAL.personajes.size()
	if GLOBAL.index_seleccion == GLOBAL.index_seleccion2:
		GLOBAL.index_seleccion = (GLOBAL.index_seleccion + 1) % GLOBAL.personajes.size()
	update_portrait1(GLOBAL.index_seleccion)

func _on_izq_1_pressed() -> void:
	var prev_index = GLOBAL.index_seleccion
	GLOBAL.index_seleccion = (GLOBAL.index_seleccion - 1 + GLOBAL.personajes.size()) % GLOBAL.personajes.size()
	if GLOBAL.index_seleccion == GLOBAL.index_seleccion2:
		GLOBAL.index_seleccion = (GLOBAL.index_seleccion - 1 + GLOBAL.personajes.size()) % GLOBAL.personajes.size()
	update_portrait1(GLOBAL.index_seleccion)

func _on_dere_2_pressed() -> void:
	var prev_index = GLOBAL.index_seleccion2
	GLOBAL.index_seleccion2 = (GLOBAL.index_seleccion2 + 1) % GLOBAL.personajes2.size()
	if GLOBAL.index_seleccion2 == GLOBAL.index_seleccion:
		GLOBAL.index_seleccion2 = (GLOBAL.index_seleccion2 + 1) % GLOBAL.personajes2.size()
	update_portrait2(GLOBAL.index_seleccion2)

func _on_izq_2_pressed() -> void:
	var prev_index = GLOBAL.index_seleccion2
	GLOBAL.index_seleccion2 = (GLOBAL.index_seleccion2 - 1 + GLOBAL.personajes2.size()) % GLOBAL.personajes2.size()
	if GLOBAL.index_seleccion2 == GLOBAL.index_seleccion:
		GLOBAL.index_seleccion2 = (GLOBAL.index_seleccion2 - 1 + GLOBAL.personajes2.size()) % GLOBAL.personajes2.size()
	update_portrait2(GLOBAL.index_seleccion2)

func _on_play_pressed() -> void:
	start_transition("res://escenas/Menús/seleccion del mapa.tscn")


func start_transition(nivel_path):
	color_rect_3.visible = true  # Hace visible el ColorRect antes de la animación
	animation_player.play("pasar")  # Reproduce la animación
	await animation_player.animation_finished  # Espera a que termine la animación
	get_tree().change_scene_to_file(nivel_path)  # Cambia de escena
