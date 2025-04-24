extends CharacterBody2D

# Constantes de física
var SPEED = 100
var GRAVITY = 980
var JUMP_VELOCITY = -400

# Referências aos nós
@onready var player: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $Anim
@onready var hurt_timer: Timer = $HurtTimer
@onready var area: Area2D = $Area2D

# Exportáveis e variáveis auxiliares
@export var speed_player: float = 1
@export var playerImage: Array[Texture2D]

var double_jump = false
var is_hurt = false
var last_checkpoint_position: Vector2 = Vector2(-97, 227) # Posição inicial

func _ready():
	area.body_entered.connect(_on_body_entered)
	hurt_timer.timeout.connect(_on_HurtTimer_timeout)
	hurt_timer.wait_time = 1.5
	hurt_timer.one_shot = true

func _physics_process(delta):
	if is_hurt:
		return
	
	# Aplicar gravidade
	velocity.y += GRAVITY * delta
	
	# Movimento horizontal
	var direction = Input.get_axis("walk_left", "walk_rigth")
	velocity.x = direction * SPEED * speed_player

	# Pulo
	if Input.is_action_just_pressed("jump") and (is_on_floor() or not double_jump):
		velocity.y = JUMP_VELOCITY
		if is_on_floor():
			double_jump = false
		else:
			double_jump = true

	# Flip horizontal do personagem
	if direction > 0:
		player.flip_h = false
	elif direction < 0:
		player.flip_h = true

	# Animações
	if is_on_floor():
		if direction == 0:
			anim.play("idle")
		else:
			anim.play("walk")
	else:
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
	
	# Mover o personagem
	move_and_slide()

func take_damage():	
	anim.play("hurt")
	
	is_hurt = true
	velocity = Vector2.ZERO
	
	# Adicione um efeito visual de piscar (opcional)
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
	
	hurt_timer.start()
	
	# Volta para o checkpoint após a animação
	await hurt_timer.timeout
	global_position = last_checkpoint_position
	is_hurt = false

func _on_body_entered(body):
	if "Enemie" in body.name and not is_hurt:  
		take_damage()

func _on_HurtTimer_timeout():
	pass 

func update_checkpoint_position(new_position: Vector2):
	last_checkpoint_position = new_position
