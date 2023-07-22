extends Area2D

onready var animation_player := $AnimationPlayer

func apply_effect(body: Node) -> void:
	pass
	
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		animation_player.play("destroy")
		apply_effect(body)
