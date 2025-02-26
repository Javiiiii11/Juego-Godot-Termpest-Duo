extends Node2D



func _on_cerrar_nivel_pressed() -> void:
	get_tree().paused = false
	GLOBAL.salir = true


func _on_repetir_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	get_tree().reload_current_scene()  # Esto recarga la escena actual y restablece todo


func _on_continuar_nivel_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	pass # Replace with function body.
