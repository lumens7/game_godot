extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_left: RayCast2D = $Ray
@onready var ray_right: RayCast2D = $RayTwo
@onready var ray_front: RayCast2D = $RayFront
@onready var trigger_area: Area2D = $TriggerArea
@onready var damage_area: Area2D = $DamageArea

# Configurações
var speed = 80
var moving_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Estados
var spikes_active = false
var waiting_to_move = false

func _ready():
	add_to_group("enemies")
	
	trigger_area.set_collision_mask_value(1, true)  
	trigger_area.set_collision_layer_value(3, true) 
	
	damage_area.set_collision_mask_value(1, true)  
	damage_area.set_collision_layer_value(4, true)
	
	trigger_area.body_entered.connect(_on_trigger_entered)
	damage_area.body_entered.connect(_on_damage_entered)
	set_damage_area(false)
	anim.play("walk")

func _physics_process(delta):
	if waiting_to_move:
		return
	# Aplicar gravidade
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.y = 0
	
	handle_movement()
	move_and_slide()
	update_animation()

func handle_movement():
	var current_ray = ray_right if moving_right else ray_left
	
	# Verifica apenas paredes (ignora player)
	if ray_front.is_colliding() and not ray_front.get_collider().name == "Player":
		flip_direction()
		return
	
	if not current_ray.is_colliding():
		flip_direction()
		return
	
	velocity.x = speed if moving_right else -speed

func flip_direction():
	moving_right = !moving_right
	anim.flip_h = moving_right
	ray_front.position.x *= -1
	ray_front.target_position.x *= -1

func update_animation():
	if spikes_active:
		return
		
	if abs(velocity.x) > 10:
		anim.play("walk")
	else:
		anim.play("walk")

func set_damage_area(active: bool):
	damage_area.monitoring = active
	damage_area.monitorable = active
	damage_area.get_child(0).disabled = !active

func _on_trigger_entered(body):
	if body.name == "Player" and not spikes_active:
		activate_spikes()

func _on_damage_entered(body):
	if body.name == "Player" and spikes_active and body.has_method("take_damage"):
		body.take_damage()

func activate_spikes():
	if spikes_active: 
		return
	
	spikes_active = true
	waiting_to_move = true
	velocity = Vector2.ZERO
	
	anim.play("Spikes_out")
	await anim.animation_finished
	
	set_damage_area(true)
	anim.play("walk_Spikes")
	waiting_to_move = false
	
	await get_tree().create_timer(10.0).timeout
	deactivate_spikes()

func deactivate_spikes():
	if not spikes_active:
		return
	
	spikes_active = false
	waiting_to_move = true
	velocity = Vector2.ZERO
	
	anim.play("Spikes_in")
	await anim.animation_finished
	
	set_damage_area(false)
	waiting_to_move = false
	anim.play("walk")
