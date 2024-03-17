extends CanvasLayer

@onready var egg_counter_label: Label = $Control/VBoxContainer/HBoxContainer/TextureButton3/egg_counter_label

@onready var wave_label_amount_label: Label = $Control/VBoxContainer/HBoxContainer2/wave_label_amount_label
@onready var wave_time_amount_label: Label = $Control/VBoxContainer/HBoxContainer2/wave_time_amount_label


func _ready() -> void:
	Events.update_egg_ui.connect(_on_update_egg_ui)
	Events.wave_timer_update.connect(_on_wave_timer_update)
	Events.wave_counter_update.connect(_on_wave_counter_update)

func _on_wave_counter_update(wave):
	wave_label_amount_label.text = str(wave)	

func _on_wave_timer_update(seconds):
	wave_time_amount_label.text = str(seconds)

func _on_update_egg_ui(score):
	egg_counter_label.text = str(score).pad_zeros(3)


func _on_collector_purchase_button_pressed() -> void:
	Events.purchase_collector.emit()

func _on_protector_purchase_button_pressed() -> void:
	Events.purchase_protector.emit()
