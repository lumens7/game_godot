extends Node2D

class_name Fruit_Random

signal fruit_eaten

@export var list_fruits: Array[Texture2D]

@onready var animation_fruit: AnimationPlayer = $AnimationFruit
@onready var apple: Sprite2D = $Apple

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var n = randi_range(0, list_fruits.size()-1)
	apple.texture = list_fruits[n]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation_fruit.play("stop")
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	fruit_eaten.emit()
	queue_free()
