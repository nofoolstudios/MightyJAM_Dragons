extends Area2D

var total_eggs = 3

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	Events.purchase_collector.connect(_on_purchase_collector)
	Events.purchase_protector.connect(_on_purchase_protector)
	Events.record_final_score.connect(_on_record_final_score)
	Events.update_egg_ui.emit(total_eggs)

func _on_record_final_score():
	Events.record_final_egg_count.emit(total_eggs)

func _on_purchase_collector():
	if check_if_can_purchase(2):
		total_eggs -= 2
		Events.purchase_successful.emit("collector")
		Events.update_egg_ui.emit(total_eggs)

func _on_purchase_protector():
	if check_if_can_purchase(3) and !Events.mouse_holding_building:
		total_eggs -= 3
		Events.purchase_successful.emit("protector")
		Events.update_egg_ui.emit(total_eggs)

func check_if_can_purchase(cost) -> bool :
	if total_eggs - cost >= 0:
		return true
	else:
		return false

func _on_area_entered(area):
	if area.is_in_group("collector"):
		if area.get_parent().egg_container != null:
			var new_egg = area.get_parent().egg_container.instantiate()
			area.get_parent().egg_container = null
			total_eggs += new_egg.points
			Events.update_egg_ui.emit(total_eggs)
			print(total_eggs)
