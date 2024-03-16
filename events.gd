extends Node

var final_egg_count
var mouse_holding_building

#UI
signal update_egg_ui(score)
signal record_final_egg_count(count)
signal game_over_ready
signal record_final_score
signal purchase_collector
signal purchase_protector
signal purchase_successful(type: String)
signal wave_counter_update(time)

#functionality
signal mouse_in_use
signal building_place


func _ready() -> void:
	mouse_in_use.connect(_on_mouse_in_use)
	building_place.connect(_on_building_placed)
	record_final_egg_count.connect(_on_get_final_egg_count)
	
func _on_get_final_egg_count(count):
	final_egg_count = count
	game_over_ready.emit()
	
func _on_mouse_in_use():
	mouse_holding_building = true

func _on_building_placed():
	mouse_holding_building = false
