extends "Pickup.gd"

func apply_effect(body: Node) -> void:
	body.toggle_cooldown_effect(true)
