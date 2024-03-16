extends Panel

@onready var play_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/play_button
@onready var credits_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/credits_button
@onready var exit_game_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/exit_game_button
@onready var settings_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/settings_button
@onready var how_to_play_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/how_to_play_button

@onready var menu_credits: Panel = $"../Menu_Credits"
@onready var menu_home: Panel = $"."
@onready var menu_settings: Panel = $"../Menu_Settings"
@onready var menu_how_to: Panel = $"../Menu_How_To"



func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	exit_game_button.pressed.connect(_on_exit_game_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	how_to_play_button.pressed.connect(_on_how_to_button_pressed)


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_manager.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	menu_home.hide()
	menu_credits.hide()
	menu_how_to.hide()
	menu_settings.show()
	
func _on_how_to_button_pressed():
	menu_home.hide()
	menu_credits.hide()
	menu_settings.hide()
	menu_how_to.show()

func _on_credits_button_pressed():
	menu_home.hide()
	menu_settings.hide()
	menu_how_to.hide()
	menu_credits.show()
