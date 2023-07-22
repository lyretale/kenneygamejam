extends Area2D

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		animation_player.play("occupied")
		apply_effect(body)






