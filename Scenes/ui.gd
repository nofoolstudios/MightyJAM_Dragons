extends Control

@export var game_manager : GameManager
@onready var resume_button: TextureButton = $Panel/NinePatchRect/MarginContainer/VBoxContainer/resume_button


func _ready() -> void:
	hide()
	game_manager.toggle_game_paused.connect(_on_game_manger_toggle_game_paused)

	
func _on_game_manger_toggle_game_paused(is_paused: bool):
	if(is_paused):
		show()
	else:
		hide()

func _on_resume_button_pressed() -> void:
	print("paused unpaused")
	game_manager.game_pasued = false

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_manager.tscn")
