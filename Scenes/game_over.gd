extends Control

@onready var eggs_label: Label = $Menu_Home/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/eggs_label

func _ready() -> void:
	eggs_label.text = str(Events.final_egg_count)

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_manager.tscn")
