extends "res://base_goblin.gd"


const RIGHT = 1
const LEFT = -1

@onready var interaction_box: Area2D = $interaction_box
@onready var interaction_block_timer: Timer = $interaction_block_timer
@onready var egg_sprite: Sprite2D = $egg_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var egg_container: PackedScene
@export var move_speed = 50
@export var interaction_speed = 1.0
@onready var hit_animation_player: AnimationPlayer = $hit_animation_player


var is_interacting = false
var is_interaction_timer_set = false
var is_entering = true
var is_empty_handed = true
var current_egg = ""
var current_weight = 0.0

var direction = Vector2.RIGHT
var destination = Vector2.ZERO



enum tasks {COLLECTING, DELIVERING}
var current_task = tasks.COLLECTING

enum states {ENTERING, THINKING, WALKING, INTERACTION}
var current_state = states.ENTERING


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print(current_state)

	if current_state == states.ENTERING:
		if destination.x > position.x:
			position.x += move_speed * delta
			animation_player.play("walk")
		else:
			is_targetable = true
			is_entering = false
			current_state = states.WALKING
			
	if current_state == states.WALKING:
		if current_task == tasks.COLLECTING:
			position.x += move_speed * delta
			scale.x = RIGHT
		elif current_task == tasks.DELIVERING:
			position.x -= move_speed * delta
			scale.x = LEFT
		animation_player.play("walk")
		
	if current_state == states.THINKING:
		if current_task == tasks.COLLECTING and not is_empty_handed:
			print("switching to delivery")
			interaction_block_timer.start()
			current_task = tasks.DELIVERING
			current_state = states.WALKING
			
		elif current_task == tasks.DELIVERING and is_empty_handed:
			print("switching to collecting")
			interaction_block_timer.start()
			current_task = tasks.COLLECTING
			current_state = states.WALKING
		
		current_state = states.WALKING
			
	if current_state == states.INTERACTION:
		position = position
		animation_player.play("idle")
		await get_tree().create_timer(interaction_speed).timeout
		
		
		if not is_empty_handed:
			generate_sprite()
			egg_sprite.show()
		if is_empty_handed:
			egg_sprite.hide()
			
		current_state = states.THINKING

func generate_sprite():
	if egg_container != null:
		var new_egg = egg_container.instantiate()
		egg_sprite.texture = new_egg.texture

func connect_required_signals():
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)
	interaction_box.area_entered.connect(_on_interaction_box_entered)
	interaction_block_timer.timeout.connect(_on_interaction_block_timer_timeout)

func _on_interaction_block_timer_timeout():
	is_interacting = false

func _on_interaction_box_entered(area):
	if not is_interacting and not is_entering:
		is_interacting = true
		
		if area.is_in_group("cart"):
			is_empty_handed = true
			current_state = states.INTERACTION
			pass
		
		if area.is_in_group("nest"):
			is_empty_handed = false
			current_state = states.INTERACTION
			pass
	
