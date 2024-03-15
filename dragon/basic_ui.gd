extends Control

@onready var egg_total_label: Label = $egg_total_label


func _ready() -> void:
	Events.update_egg_ui.connect(_on_update_egg_ui)
	
func _on_update_egg_ui(score):
	egg_total_label.text = "EGGS: " + str(score)
