extends CheckButton


func _on_toggled(toggled_on: bool) -> void:
	BackgroundAudio.stream_paused = !toggled_on
