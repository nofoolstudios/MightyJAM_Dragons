extends Panel

@onready var main_menu_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/main_menu_button
@onready var exit_game_button: TextureButton = $NinePatchRect/MarginContainer/VBoxContainer/exit_game_button

@onready var menu_credits: Panel = $"../Menu_Credits"
@onready var menu_settings: Panel = $"."
@onready var menu_home: Panel = $"../Menu_Home"

func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	exit_game_button.pressed.connect(_on_exit_game_button_pressed)
	
func _on_main_menu_button_pressed():
	menu_credits.hide()
	menu_settings.hide()
	menu_home.show()

func _on_exit_game_button_pressed():
	get_tree().quit()
