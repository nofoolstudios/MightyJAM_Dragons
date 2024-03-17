extends Area2D

const GOBLIN_EXPLOSION_EFFECT = preload("res://Scenes/goblin_explosion_effect.tscn")

@onready var hurt_box: Area2D = $hurt_box
@onready var damage_animation_player: AnimationPlayer = $DamageAnimationPlayer

@export var health = 3
@export var type: String = "basic"
var is_targetable = false

func _ready() -> void:
	connect_required_signals()

func _process(delta: float) -> void:
	pass
	
func connect_required_signals():
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_hurt_box_area_entered(area):
	if area.target == self:
		health -= area.damage
		damage_animation_player.play("damage_taken")
		area.queue_free()
	if health > 0:
		return
	else:
		create_explosion()
		queue_free()

func create_explosion():
	var new_explosion = GOBLIN_EXPLOSION_EFFECT.instantiate()
	var world = get_tree().current_scene
	new_explosion.position = position
	world.add_child(new_explosion)
