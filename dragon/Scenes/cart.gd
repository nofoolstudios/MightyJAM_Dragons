extends Area2D

var total_eggs = 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("collector"):
		if area.get_parent().egg_container != null:
			var new_egg = area.get_parent().egg_container.instantiate()
			area.get_parent().egg_container = null
			total_eggs += new_egg.points
			Events.update_egg_ui.emit(total_eggs)
			print(total_eggs)
