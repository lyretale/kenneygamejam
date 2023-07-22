extends "Pickup.gd"

func apply_effect(body: Node) -> void:
	body.toggle_attack_boost_effect(true)

