extends CanvasLayer

@onready var egg_counter_label: Label = $Control/VBoxContainer/HBoxContainer/TextureButton3/egg_counter_label

func _ready() -> void:
	Events.update_egg_ui.connect(_on_update_egg_ui)

func _on_update_egg_ui(score):
	egg_counter_label.text = str(score).pad_zeros(3)


func _on_collector_purchase_button_pressed() -> void:
	Events.purchase_collector.emit()

func _on_protector_purchase_button_pressed() -> void:
	Events.purchase_protector.emit()
