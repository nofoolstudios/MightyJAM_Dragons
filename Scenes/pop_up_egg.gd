extends Node2D

@onready var egg_amount: Label = $Control/HBoxContainer/egg_amount

var amount = 0

func _ready() -> void:
	egg_amount.text = "+" + str(amount)
