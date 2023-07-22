extends "Pickup.gd"

func add_gold_stack(body: Node) -> void:
	body.gain_gold_stack(true)
