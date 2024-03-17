extends Area2D

const YELLOW_EGG = preload("res://Scenes/yellow_egg.tscn")
const BLUE_EGG = preload("res://Scenes/blue_egg.tscn")
const RED_EGG = preload("res://Scenes/red_egg.tscn")
var looted_egg 


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("collector"):
		print("collector found")
		generate_random_egg()
		area.get_parent().egg_container = looted_egg

func generate_random_egg():
	var number = randi_range(1, 100)
	if number < 60:
		looted_egg = YELLOW_EGG
	elif number > 90:
		looted_egg = RED_EGG
	else:
		looted_egg = BLUE_EGG
