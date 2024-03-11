extends Node3D

const base_text = "Click to "

var can_interact = false

var active_area

func register_area(area):
	active_area = area
	can_interact = true
	

func unregister_area():
	can_interact = false


func _input(event: InputEvent) -> void:
	if active_area != null:
		if event.is_action_pressed("interact") and active_area.is_in_group("CoinPlacement") and can_interact:
			active_area.interact.call()
			can_interact = false
