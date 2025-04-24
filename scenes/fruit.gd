extends Node2D

class_name Fruit
@onready var animation_fruit: AnimationPlayer = $AnimationFruit

#Fruta comida
signal fruit_eaten

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	animation_fruit.play("stop")
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	fruit_eaten.emit() #emitir sinal
	queue_free() #Remove o elemento
