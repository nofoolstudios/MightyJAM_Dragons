extends AudioStreamPlayer
@onready var background_audio: AudioStreamPlayer = $"."

func _on_finished() -> void:
	playing = true
