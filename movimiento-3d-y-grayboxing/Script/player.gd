extends Node3D

@onready var player = $CharacterBody3D

@export var speed = 14.0
@export var aceleracion_caida = 75.0
@export var impuslo_salto = 20.0
@export var fuerza_dash = 50.0

signal monedas_cambiaron(cantidad)

var target_velocity = Vector3.ZERO
var doble_salto = true
var dash = true
var haciendo_dash = false
var ultima_direccion = Vector3.ZERO
var contador_monedas: int

func _ready() -> void:
	contador_monedas = 0

func _process(delta: float) -> void:
	if contador_monedas == 3:
		get_tree().reload_current_scene()
		#get_tree().quit()

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("delante"):
		direction.z -= 1
	if Input.is_action_pressed("detrás"):
		direction.z += 1
	if Input.is_action_pressed("derecha"):
		direction.x += 1
	if Input.is_action_pressed("izquierda"):
		direction.x -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		ultima_direccion = direction
		$CharacterBody3D/Pivote.basis = Basis.looking_at(direction)
	
	if Input.is_action_just_pressed("dash") and dash and direction != Vector3.ZERO:
		hacer_dash(direction)
	
	if Input.is_action_just_pressed("reiniciar"):
		get_tree().reload_current_scene()
	
	if haciendo_dash:
		player.move_and_slide()
		return
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not player.is_on_floor():
		target_velocity.y = target_velocity.y - (aceleracion_caida * delta)
		if Input.is_action_just_pressed("salto") and doble_salto == true:
			target_velocity.y = impuslo_salto
			doble_salto = false
	
	player.velocity = target_velocity
	
	if player.is_on_floor():
		doble_salto = true
		if Input.is_action_just_pressed("salto"):
			target_velocity.y = impuslo_salto
	
	player.move_and_slide()

func hacer_dash(direction: Vector3) -> void:
	dash = false
	haciendo_dash = true
	
	player.velocity = direction * fuerza_dash
	player.velocity.y = 0
	
	var dash_duration = 0.2
	await get_tree().create_timer(dash_duration).timeout
	
	haciendo_dash = false
	
	var dash_cooldown = 2.0
	await get_tree().create_timer(dash_cooldown).timeout
	
	dash = true

func aumentar_moneda():
	contador_monedas += 1
	monedas_cambiaron.emit(contador_monedas)
