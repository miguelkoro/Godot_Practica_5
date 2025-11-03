extends CharacterBody2D

@export var speed:float = 100
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_jump: AudioStreamPlayer2D = $AudioStream_Jump
@onready var audio_hurt: AudioStreamPlayer2D = $AudioStream_Hurt
@onready var checkpoint_start: Marker2D = $"../CheckPoints/CheckPoint_Start"
@onready var coins: Node2D = $"../Coins"


#Guardamos la direccion en la que se mueve el personje
var direction: Vector2 = Vector2.ZERO
var isMoving: bool = false
var isDead: bool = false
var animation_rotation: int = 0


#Si el personaje no se esta moviendo, podemos aceptar el input del teclado
func _process(delta: float) -> void:
	if not isMoving and not isDead:
		handle_input()
		
#Pillamos el input del teclado para ver en que direccion se mueve  el personaje
func handle_input() -> void:
	if Input.is_action_just_pressed("ui_up"):
		start_moving(Vector2.UP)		
	elif Input.is_action_just_pressed("ui_down"):
		start_moving(Vector2.DOWN)
	elif Input.is_action_just_pressed("ui_left"):
		start_moving(Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		start_moving(Vector2.RIGHT)
		

func start_moving(dir: Vector2) -> void:
	direction = dir.normalized()
	isMoving = true
	audio_jump.play()
	animate(dir)
	
func animate(dir: Vector2) -> void:
	animated.play("walk_right")
	if dir == Vector2.LEFT:
		if animation_rotation == 00:
			animated.flip_h = true
		else:
			animated.flip_h = false
	elif dir == Vector2.UP:
		if animation_rotation == 90:
			animated.flip_h = true
		else:
			animated.flip_h = false
	elif dir == Vector2.DOWN:
		if animation_rotation == -90:
			animated.flip_h = true
		else:
			animated.flip_h = false
	elif dir == Vector2.RIGHT:
		if animation_rotation == 180:
			animated.flip_h = true
		else:
			animated.flip_h = false
	else:
		animated.flip_h = false

func _physics_process(delta: float) -> void:
	if isMoving:
		var motion = direction * speed * delta
		var collision = move_and_collide(motion)
		if collision:
			check_collision(collision.get_collider())			 
		
func check_collision(collider) -> void:
	if collider.is_in_group("Spikes"):
		die()
	else:
		rotate_sprite(direction)
		isMoving = false
		check_height()
		velocity = Vector2.ZERO
		animated.play("idle")
		
func check_height() -> void:
	var height = int(abs(position.y / 16)) # -8/16=0 , -32/16=2 ...
	print(height)
	GameManager.set_height(height)
		
func die() -> void:
	print("💀 Has tocado los pinchos")
	audio_hurt.play()
	velocity = Vector2.ZERO
	rotate_sprite(direction)
	animated.play("die") #Ponemos la animacion de morir
	isMoving = false
	isDead = true
	var water = get_tree().get_first_node_in_group("Water") #Reiniciamos el agua tambien (Por si se ha muerto por pinchos)
	water.restart()
	await get_tree().create_timer(2).timeout # espera 1.5 segundos
	respawn()

func respawn() -> void:	
	animated.play("idle")
	isDead = false
	position = checkpoint_start.position
	direction = Vector2.ZERO
	#animation_rotation = 0
	#animated.rotation_degrees = animation_rotation
	rotate_sprite(Vector2.DOWN)
	animated.flip_h = false
	GameManager.restart() #Reiniciamos los stats

	for coin in coins.get_children():
		coin.restart()
	
			
func rotate_sprite(dir: Vector2) -> void:
	match dir:
		Vector2.UP:
			animation_rotation = 180
		Vector2.DOWN:
			animation_rotation = 0
		Vector2.LEFT:
			animation_rotation = 90
		Vector2.RIGHT:
			animation_rotation = -90
	animated.rotation_degrees = animation_rotation
