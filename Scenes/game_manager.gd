extends Node
class_name GameManager

signal toggle_game_paused(is_paused: bool)

func _ready() -> void:
	game_pasued = false

var game_pasued: bool = false:
	get:
		return game_pasued
	set(value):
		game_pasued = value
		get_tree().paused = game_pasued
		emit_signal("toggle_game_paused", game_pasued)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_pasued = !game_pasued
		
