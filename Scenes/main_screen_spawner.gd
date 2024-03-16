extends Node2D

const WHELP = preload("res://Scenes/whelp.tscn")

@export var direction = true
@onready var spawn_timer: Timer = $spawn_timer
@onready var spawn_area: TextureRect = $spawn_area

func _ready() -> void:
	hide()
	spawn_timer.timeout.connect(_on_spawn_timer_timerout)

func _on_spawn_timer_timerout():
	var main_menu = get_tree().current_scene.get_node("dragons")
	var new_spawn_area = spawn_area.get_global_rect()
	var new_whelp = WHELP.instantiate()
	new_whelp.is_on_main_screen = true
	if direction:
		new_whelp.direction = Vector2.RIGHT
	elif not direction:
		new_whelp.direction = Vector2.LEFT

	new_whelp.position.y = randi_range(0, new_spawn_area.end.y)
	main_menu.add_child(new_whelp)
