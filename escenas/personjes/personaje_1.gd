extends CharacterBody2D

@export var movimiento: float 
@export var rodando:bool
@export var salto: float
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var skin: AnimatedSprite2D = $skin


var character_skin = 0

func _ready() -> void:
	character_skin = GLOBAL.index_seleccion
	
		
func _physics_process(delta):
	move_x()
	flip()
	jump(delta)
	rodar()
	update_animations()
	move_and_slide()

	
func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right
	
func move_x():
	var input_controles = Input.get_axis("Izq1", "Dere1")
	if rodando:
		velocity.x = input_controles * movimiento * 2
	else:
		velocity.x = input_controles * movimiento
		
func jump(delta):
	if Input.is_action_just_pressed("Salto1") and is_on_floor():
		velocity.y = -salto	
	if not is_on_floor():
		velocity.y += gravity * delta

func rodar():
	if Input.is_action_just_pressed("rodar1") and is_on_floor():
		rodando = true  # Activa el estado de rodar

		# Crear e inicializar el temporizador
		var timer = Timer.new()
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.timeout.connect(_detener_rodar)  # Conectar la señal
		add_child(timer)
		timer.start()

		# Iniciar animación de rodar
		skin.play("rodar" + str(character_skin))

func _detener_rodar():
	rodando = false  # Se desactiva cuando el Timer termina
func update_animations():

	if velocity.y < 0:  # Si está subiendo
		if rodando:
			skin.play("rodar" + str(character_skin))
		else:
			skin.play("salto" + str(character_skin))
	elif velocity.y > 0:  # Si está cayendo
		skin.play("caer" + str(character_skin))
	elif rodando:  # Si la velocidad es mayor que la normal, está rodando
		skin.play("rodar" + str(character_skin))
	elif velocity.x != 0:  # Si solo está caminando
		skin.play("mover" + str(character_skin))
	else:  # Si está quieto
		skin.play("quieto" + str(character_skin))
		
@export var ground_layer: int = 1  # Capa de colisión normal
@export var jump_layer: int = 2    # Capa de colisión al saltar
