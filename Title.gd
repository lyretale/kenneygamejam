extends NinePatchRect

onready var button = $Button



func _on_Button_pressed() -> void:
	get_tree().change_scene("res://World.tscn")
