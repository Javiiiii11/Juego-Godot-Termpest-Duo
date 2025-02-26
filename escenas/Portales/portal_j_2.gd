extends Node2D

@onready var portal: AnimatedSprite2D = $AnimatedSprite2D

var color = GLOBAL.index_seleccion2
var portal_abierto = false  # Variable de control

func _ready() -> void:
	portal.visible = false

func _process(delta: float) -> void:
	if GLOBAL.portal2Abierto:
		aparecerPortal()

func aparecerPortal():
	if not portal_abierto:
		portal.visible = true
		portal.play(str(color) + "abrir")
		await get_tree().create_timer(0.6).timeout 
		#await portal.animation_finished
		portal_abierto = true  # Evita que se repita
	else:
		portal.play(str(color) + "quieto")
