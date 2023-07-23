extends Node2D


func _ready() -> void:
	spawn_enemies(3)


func spawn_enemies(number: int) -> void:
	for i in range(number):
		spawn_enemy()


func spawn_enemy() -> void:
	# pick random location
	pass
