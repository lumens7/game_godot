extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var itens: Node2D = $Itens
@onready var checkpoints: Node2D = $Checks

var num_fruits:int = 0
var initial_position = Vector2(-97, 227)

func _ready() -> void:
	# Conectar frutas
	for item in itens.get_children():
		if item is Fruit or item is Fruit_Random:
			item.fruit_eaten.connect(_on_fruit_eaten)
	
	# Conectar checkpoints
	for checkpoint in checkpoints.get_children():
		checkpoint.checkpoint_activated.connect(_on_checkpoint_activated)
	
	# Definir posição inicial do player
	player.last_checkpoint_position = initial_position

func _on_fruit_eaten():
	pass

func _on_checkpoint_activated(position: Vector2):
	# Atualizar a posição do checkpoint para todos os checkpoints
	for checkpoint in checkpoints.get_children():
		if checkpoint.global_position == position:
			checkpoint.is_active = true
		else:
			checkpoint.is_active = false
			checkpoint.check_point.play("stop")
	
	# Atualizar a posição do checkpoint no player
	player.update_checkpoint_position(position)
