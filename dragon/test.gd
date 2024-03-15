extends Node2D

var direction = Vector2(-1,0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		direction.x * -1
		print(direction)
