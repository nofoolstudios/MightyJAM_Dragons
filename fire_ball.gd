extends Area2D

@export var speed = 5
var damage = 0
var direction = Vector2.ZERO
var target


func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func set_damage(value):
	damage = value
