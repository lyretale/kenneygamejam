extends Node2D


export var world_stats: Resource = null
onready var enemies = $Level/Enemies
onready var enemies_turrets = $Level/EnemiesTurrets
onready var bullets = $Bullets
onready var water_tiles = $Level/Tilemap/TileMapWater
var basic_enemy = preload("res://enemies/EnemyBasic.tscn")
var basic_enemy_turret = preload("res://enemies/EnemyTurret.tscn")


func _ready() -> void:
	randomize()
	spawn_enemies(10)


func spawn_enemies(number: int) -> void:
	for i in range(number):
		spawn_enemy()


func spawn_enemy() -> void:
	var used_cells = water_tiles.get_used_cells()
	
	var random_cell = used_cells[randi() % used_cells.size()]
	var local_cell_pos = water_tiles.map_to_world(random_cell)
	var global_cell_pos = to_global(local_cell_pos)
	
	var new_enemy_instance = basic_enemy.instance()
	var new_enemy_turret_instance = basic_enemy_turret.instance()
	enemies.add_child(new_enemy_instance)
	
	
	var origin = global_cell_pos + water_tiles.cell_size * 0.5
	new_enemy_instance.origin = origin
	new_enemy_instance.global_position = origin
	new_enemy_turret_instance.global_position = origin
	new_enemy_turret_instance.target_path = new_enemy_instance.get_path()
	new_enemy_turret_instance.bullets_path = bullets.get_path()
	enemies_turrets.add_child(new_enemy_turret_instance)
	new_enemy_instance.assign_turret(new_enemy_turret_instance.get_path())
	
