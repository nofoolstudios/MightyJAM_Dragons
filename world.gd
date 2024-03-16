extends Node2D

const GOBLIN_PROTECTOR = preload("res://Scenes/goblin_protector.tscn")
const GOBLIN_COLLECTOR = preload("res://Scenes/collector_goblin.tscn")
const WHELP = preload("res://Scenes/whelp.tscn")

@onready var whelp_spawn_points: Node2D = $whelp_spawn_points
@onready var goblin_spawn_point_1: Marker2D = $goblin_spawn_points/sp1
@onready var goblin_destination: Marker2D = $goblin_spawn_points/sp2

@onready var wave_timer: Timer = $wave_timer
@onready var goblin_protectors: Node2D = $goblin_protectors
@onready var goblin_collectors: Node2D = $goblin_collectors

func _ready() -> void:
	spawn_collector()
	Events.purchase_successful.connect(_on_purchase_successful)
	Events.game_over_ready.connect(_on_game_over_ready)
	
func _process(delta: float) -> void:
	var all_goblin_collectors = goblin_collectors.get_children()
	var all_goblin_protectors = goblin_protectors.get_children()
	var all_goblins = []
		
	if all_goblin_collectors.size() != 0:
		for goblins in all_goblin_collectors:
			all_goblins.append(goblins)
				
	if all_goblin_protectors.size() != 0:
		for goblins in all_goblin_protectors:
			all_goblins.append(goblins)
	
	if all_goblins.is_empty():
		Events.record_final_score.emit()
	
	if Input.is_action_just_pressed("spawn_whelp"):
		if all_goblins.size() != 0:
			var goblin_destination = all_goblins.pick_random()
			var random_height = randf_range(-40,-70)
			var new_whelp = WHELP.instantiate()
			var spawn_array = whelp_spawn_points.get_children()
			var spawn_point = spawn_array.pick_random()
			new_whelp.position = spawn_point.position
			new_whelp.destination = goblin_destination.global_position + Vector2(0,random_height)
			add_child(new_whelp)
			
func _on_purchase_successful(type):
	if type == "collector":
		spawn_collector()
	elif type == "protector":
		spawn_protection()

func spawn_protection():
	if not Events.mouse_holding_building: 
		var new_protector = GOBLIN_PROTECTOR.instantiate()
		goblin_protectors.add_child(new_protector)
		Events.mouse_in_use.emit()
	else:
		print("place down building first")

func spawn_collector():
	var new_collector = GOBLIN_COLLECTOR.instantiate()
	new_collector.position = goblin_spawn_point_1.position
	new_collector.destination.x = goblin_destination.position.x
	goblin_collectors.add_child(new_collector)

func _on_game_over_ready():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
