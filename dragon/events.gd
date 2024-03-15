extends Node

var mouse_holding_building


#UI
signal update_egg_ui(score)

#functionality
signal mouse_in_use
signal building_place


func _ready() -> void:
	mouse_in_use.connect(_on_mouse_in_use)
	building_place.connect(_on_building_placed)
	
func _on_mouse_in_use():
	mouse_holding_building = true

func _on_building_placed():
	mouse_holding_building = false
