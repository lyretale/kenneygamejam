extends "Pickup.gd"

func apply_effect(body: Node) -> void:
	body.toggle_speed_pickup_effect(true)
