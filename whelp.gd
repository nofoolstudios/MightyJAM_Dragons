extends Area2D

const FIRE_BALL = preload("res://Scenes/fire_ball.tscn")

const YELLOW_WHELP = preload("res://Assets/yellow_whelp.png")
const RED_WHELP = preload("res://Assets/red_whelp.png")
const BLUE_WHELP = preload("res://Assets/blue_whelp.png")

@onready var vision: Area2D = $Vision
@onready var aim: Marker2D = $Aim
@onready var reload_timer: Timer = $reload_timer
@onready var spawn_timer: Timer = $spawn_timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var relocation_timer: Timer = $relocation_timer
@onready var hurt_box: Area2D = $hurt_box
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var damage_animation_player: AnimationPlayer = $DamageAnimationPlayer


var is_on_main_screen = false

var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")

var is_targetable: = true
var health = 3


var fire_damage = 1.0
var fire_rate = 2.0

var is_able_to_fire = true
var is_relocating = false
var speed = 40

var destination = Vector2.ZERO
var direction = Vector2.ZERO
var direction_choices = [-1, 1]

enum states {ENTERING, THINKING, FIGHTING, RELOCATING}
var current_state = states.ENTERING

var current_targets = []
var enemy

func _ready() -> void:
	assign_random_sprite()
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	
	if not is_on_main_screen:
		connect_required_signals()
	

	

func _process(delta: float) -> void:
	if is_on_main_screen:
		position.x += direction.x * speed * delta
	
	if not is_on_main_screen:
		if current_state == states.ENTERING:
			direction = destination - position
			if position != destination:
				position += direction * delta
				
		if current_state == states.THINKING:
			direction.x = direction_choices.pick_random()
				# flip node depandant on direction
			if direction.x < 0:
				scale.x = -1
			else:
				scale.x = 1
			current_state = states.FIGHTING
		if current_state == states.FIGHTING:
			if position.x > 0 + collision_shape_2d.shape.size.x and position.x < window_width - collision_shape_2d.shape.size.x : 
				if enemy == null:
					position.x += direction.x * speed * delta
				
				if current_targets.size() != 0:
					select_enemy()
					shoot()
				else:
					enemy = null
			else:
				if direction.x > 0:
					direction.x = -1
				else:
					direction.x = 1
				current_state = states.RELOCATING
		if current_state == states.RELOCATING:
			position.x += direction.x * speed * delta
			if not is_relocating:
				relocation_timer.start()
				is_relocating = true

				
		# flip node depandant on direction
		if direction.x < 0:
			scale.x = -1
		else:
			scale.x = 1

	
func select_enemy():
	var targets_type_array = []
	if current_targets.size() != 0:
		for goblins in current_targets:
			targets_type_array.append(goblins.type)
		var enemy_index = current_targets.find("protector")
		if enemy_index != -1:
			var check_enemy = current_targets[enemy_index]
			enemy = check_enemy
		else:
			enemy_index = current_targets.find("collector")
			var check_enemy = current_targets[enemy_index]
			enemy = check_enemy
			
func turn():
	look_at(enemy.position)

func shoot():
	if is_able_to_fire:
		if enemy.is_targetable:
			var new_fire_ball = FIRE_BALL.instantiate()
			var world = get_tree().current_scene
			new_fire_ball.position = aim.global_position
			new_fire_ball.set_damage(fire_damage)
			if direction.x < 0:
				new_fire_ball.direction = enemy.position - position + aim.position
			else: 
				new_fire_ball.direction = enemy.position - position - aim.position
			new_fire_ball.rotation = (enemy.position - position + aim.position).angle()
			new_fire_ball.target = enemy
			world.add_child(new_fire_ball)
	
			reload_timer.start()
			is_able_to_fire = false


func connect_required_signals():
	vision.area_entered.connect(_on_vision_area_entered)
	vision.area_exited.connect(_on_vision_area_exited)
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	relocation_timer.timeout.connect(_on_relocation_timer_timeout)
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_screen_exited():
	print("node destroyed")
	queue_free()
	
func _on_vision_area_entered(area):
	var temp_array = []
	temp_array = vision.get_overlapping_areas()
	
	for goblin in temp_array:
		if goblin.is_in_group("goblin"):
			if current_targets.find(goblin) == -1:
				current_targets.append(goblin)

func assign_random_sprite():
	var temp_array = [YELLOW_WHELP,RED_WHELP,BLUE_WHELP]
	var new_sprite = temp_array.pick_random()
	sprite_2d.texture = new_sprite

func _on_vision_area_exited(area):
	current_targets.erase(area)

func _on_reload_timer_timeout():
	is_able_to_fire = true

func _on_spawn_timer_timeout():
	current_state = states.THINKING
	#is_targetable = true
	direction.x = 0

func _on_relocation_timer_timeout():
	current_state = states.FIGHTING
	is_relocating = false

func _on_hurt_box_area_entered(area):
	if area.target == self:
		health -= area.damage
		damage_animation_player.play("damage_taken")
		area.queue_free()
	if health > 0:
		return
	else:
		queue_free()
