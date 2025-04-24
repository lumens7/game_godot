extends Node2D

@onready var check_point: AnimatedSprite2D = $checkPoint
@onready var area: Area2D = $Area2D

var is_active = false

signal checkpoint_activated(position: Vector2)

func _ready():
	check_point.play("stop")
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if is_active:
		return
	
	if body.name == "Player":
		is_active = true
		check_point.play("starting")
		await check_point.animation_finished
		check_point.play("active")
		emit_signal("checkpoint_activated", global_position)
