extends "Pickup.gd"

func apply_effect(body: Node) -> void:
	body.gain_gold_stack(true)
