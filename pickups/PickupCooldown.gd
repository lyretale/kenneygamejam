extends "Pickup.gd"

func toogle_cooldown_pickup(body: Node) -> void:
	body.toggle_cooldown_pickup(true)

