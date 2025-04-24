extends Node2D

#Arrastar o nó com o ctrl 
@onready var player: Sprite2D = $Player


# Executado quando este nó estiver 100% carregado e 
#pronto para executar
func _ready() -> void:
	player.position.x = 50
	player.position.y = 50
	

	pass 
	
func _process(delta: float) -> void:
	#player.position.x += 1
	var speed = 4
	var screen_w = 640
	var screen_h = 360
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	#impedimento de sair fora da tela
	if player.position.x < 8.1:
		player.position.x = 8
	elif player.position.x > screen_w -8.1:
		player.position.x = screen_w - 8
		
	if player.position.y < 8.1:
		player.position.y = 8
	elif player.position.y > screen_h - 16:
		player.position.y = screen_h - 16
	
	#mudando o personagem de direção
	if(direction_x > 0):
		player.flip_h = false

	elif(direction_x < 0):
		player.flip_h = true

	
	#correção diagonal
	if direction_x != 0 and direction_y != 0:
		speed = 2
	player.position.y += speed*direction_y
	player.position.x += speed*direction_x
	pass
