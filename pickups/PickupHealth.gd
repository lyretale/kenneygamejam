extends "Pickup.gd"

func apply_effect(body: Node) -> void:
	body.toggle_heal_effect(true)

