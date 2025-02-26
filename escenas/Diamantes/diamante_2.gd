extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var diamente = GLOBAL.index_seleccion2

func _ready() -> void:
	animated_sprite_2d.play(str(diamente))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Personaje2":  
		GLOBAL.diamantes_J2 += 1  # Ahora sí estamos sumando en la variable global
		print(GLOBAL.diamantes_J2)  # Depuración: imprime el número total de diamantes recogidos
		queue_free()  # Elimina el diamante

		if GLOBAL.diamantes_J2 == 3:  # Cuando se recojan 3 diamantes, abre el portal
			GLOBAL.portal2Abierto = true
			print("¡Portal abierto!")  # Mensaje para verificar que la lógica funciona
