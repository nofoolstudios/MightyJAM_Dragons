extends "res://base_goblin.gd"

const PEBBLE = preload("res://Scenes/pebble.tscn")

@onready var vision_box: Area2D = $vision_box


@onready var reload_timer: Timer = $reload_timer
@onready var turn_timer: Timer = $turn_timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var aim_marker_right: Marker2D = $aim_markers/aim_marker_right
@onready var aim_marker_left: Marker2D = $aim_markers/aim_marker_left
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var no_build_zone_collision: CollisionShape2D = $no_build_zone/no_build_zone_collision
@onready var placement_detection: Area2D = $placement_detection
@onready var building_detection: Area2D = $building_detection
@onready var no_build_zone: Area2D = $no_build_zone
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_fx: AudioStreamPlayer = $sound_fx
@export var is_placed: = false

var pebble_damage = 1.0
var fire_rate = 3.5

var is_able_to_fire = true
var is_in_valid_build_area = false
var is_not_colliding_with_other_protectors = true
var is_placeable = false
var is_colour_reset: = false
var is_world_set_up = false
var has_just_turned = true

var turn_timer_min = 2.0
var turn_timer_max = 3.0
var is_turn_timer_set = false

var direction = Vector2.RIGHT
var direction_choices = [-1, 1]

enum states {THINKING, FIGHTING, RELOCATING}
var current_state = states.RELOCATING

var current_targets = []
var enemy

func _ready() -> void:
	modulate = Color.RED
	collision_shape_2d.disabled = true
	connect_required_signals()
	
func _physics_process(delta: float) -> void:
	if is_placed and not is_world_set_up:
		collision_shape_2d.disabled = false
		no_build_zone_collision.disabled = false
		is_world_set_up = true
	
	if is_placed and !is_colour_reset:
		modulate = Color.WHITE
		is_targetable = true
		is_colour_reset = true
	
	
	if current_state == states.THINKING:
		if not is_turn_timer_set:
			turn_timer.wait_time = randf_range(turn_timer_min,turn_timer_max)
			turn_timer.start()
			is_turn_timer_set = true
		
		if not has_just_turned:
			if direction == Vector2.RIGHT:
				sprite_2d.scale.x = -1
				vision_box.scale.x = -1
				direction = Vector2.LEFT
			else:
				sprite_2d.scale.x = 1
				vision_box.scale.x = 1
				direction = Vector2.RIGHT
			
			has_just_turned = true
			turn_timer.start()
		
		current_state = states.FIGHTING
		
	if current_state == states.FIGHTING:
		if current_targets.size() != 0:
			select_enemy()
			shoot()
		else:
			enemy = null
			animation_player.play("idle")
		
		if enemy == null and not has_just_turned:
			current_state = states.THINKING
		
	if current_state == states.RELOCATING:
		if not is_placed:
			position = get_global_mouse_position()
			if is_in_valid_build_area and is_not_colliding_with_other_protectors:
				modulate = Color.GREEN
				is_placeable = true
				
			if !is_in_valid_build_area:
				modulate = Color.RED
				is_placeable = false
				
			if is_placeable:
				if Input.is_action_just_pressed("place_tower"):
					position = position
					no_build_zone_collision.disabled = false
					sound_fx.playing = true
					is_placed = true
					Events.building_place.emit()
		else:
			current_state = states.THINKING

	
func select_enemy():
	var targets_health_array = []
	if current_targets.size() != 0:
		for whelps in current_targets:
			targets_health_array.append(whelps.health)
		var minimum_health_target = targets_health_array.min()
		var enemy_index = current_targets.find(minimum_health_target)
		var check_enemy = current_targets[enemy_index]
		enemy = check_enemy
			
func turn():
	look_at(enemy.position)

func shoot():
	if is_able_to_fire:
		if enemy.is_targetable:
			var new_pebble = PEBBLE.instantiate()
			var world = get_tree().current_scene
			if direction == Vector2.RIGHT:
				new_pebble.position = aim_marker_right.global_position
				new_pebble.direction = enemy.position - position - aim_marker_right.position
				new_pebble.rotation = (enemy.position - position + aim_marker_right.position).angle()
			elif direction == Vector2.LEFT:
				new_pebble.position = aim_marker_left.global_position
				new_pebble.direction = enemy.position - position - aim_marker_left.position
				new_pebble.rotation = (enemy.position - position + aim_marker_left.position).angle()
			new_pebble.set_damage(pebble_damage)
			new_pebble.target = enemy
			world.add_child(new_pebble)
			animation_player.play("shoot")
			reload_timer.start()
			is_able_to_fire = false


func connect_required_signals():
	#building_detection.area_entered.connect(_on_building_detection_area_entered)
	#building_detection.area_exited.connect(_on_building_detection_area_exited)
	vision_box.area_entered.connect(_on_vision_area_entered)
	vision_box.area_exited.connect(_on_vision_area_exited)
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	turn_timer.timeout.connect(_on_turn_timer_timeout)
	placement_detection.area_entered.connect(_on_placement_detection_area_entered)
	placement_detection.area_exited.connect(_on_placement_detection_area_exited)
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_turn_timer_timeout():
	has_just_turned = false
	is_turn_timer_set = false

#func _on_building_detection_area_entered(area):
	#if area.is_in_group("no_build_zone"):
		#is_not_colliding_with_other_protectors = false
		#

#func _on_building_detection_area_exited(area):
	#if area.is_in_group("no_build_zone"):
		#is_not_colliding_with_other_protectors = true
#
func _on_placement_detection_area_entered(area):
	if area.is_in_group("valid_placement_zone"):
		is_in_valid_build_area = true
		
func _on_placement_detection_area_exited(area):
	if area.is_in_group("valid_placement_zone"):
		is_in_valid_build_area = false

func _on_vision_area_entered(area):
	var temp_array = []
	temp_array = vision_box.get_overlapping_areas()
	
	for whelp in temp_array:
		if whelp.is_in_group("whelp"):
			if current_targets.find(whelp) == -1:
				current_targets.append(whelp)
		
func _on_vision_area_exited(area):
	current_targets.erase(area)

func _on_reload_timer_timeout():
	is_able_to_fire = true
