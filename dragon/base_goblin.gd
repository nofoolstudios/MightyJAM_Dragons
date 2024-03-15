extends Area2D

@onready var hurt_box: Area2D = $hurt_box

@export var health = 3

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
		area.queue_free()
	if health > 0:
		return
	else:
		queue_free()
