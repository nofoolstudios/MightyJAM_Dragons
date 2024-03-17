extends Node2D

@onready var goblin_bits_particle: CPUParticles2D = $goblin_bits_particle
@onready var goblin_blood_particle: CPUParticles2D = $goblin_blood_particle


func _ready() -> void:
	goblin_bits_particle.emitting = true
	goblin_blood_particle.emitting = true

func _on_kill_timer_timeout() -> void:
	queue_free()
