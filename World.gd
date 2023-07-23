extends Node2D


export var world_stats: Resource = null
#onready var time_elapsed := 0.0
onready var world_clock = $WorldClock
onready var enemies = $Level/Enemies
onready var enemies_turrets = $Level/EnemiesTurrets
onready var bullets = $Bullets
onready var water_tiles = $Level/Tilemap/TileMapWater
onready var objectives = $Level/Objectives
onready var player = $Level/Player
var objective = preload("res://Objective.tscn")
var basic_enemy = preload("res://enemies/EnemyBasic.tscn")
var basic_enemy_turret = preload("res://enemies/EnemyTurret.tscn")

#func _format_seconds(time : float) -> String:
#	var minutes := time / 60
#	var seconds := fmod(time, 60)
#	return "%02d:%02d" % [minutes, seconds]

#func _process(delta: float) -> void:
	#time_elapsed += delta
	#print(_format_seconds(time_elapsed))

func get_open_cell_position() -> Vector2:
	var used_cells = water_tiles.get_used_cells()
	var random_cell = used_cells[randi() % used_cells.size()]
	var local_cell_pos = water_tiles.map_to_world(random_cell)
	var global_cell_pos = to_global(local_cell_pos)
	return global_cell_pos + water_tiles.cell_size * 0.5

func _ready() -> void:
	world_clock.connect("timeout", self, "check_active_objective")
	randomize()
	spawn_enemies()

func check_active_objective() -> void:
	if not world_stats.is_active_objective:
		spawn_objective()

func spawn_objective() -> void:
	world_stats.is_active_objective = true
	var origin = get_open_cell_position()
	var new_objective_instance = objective.instance()
	new_objective_instance.global_position = origin
	#print("player.global_position: ", player.global_position)
	#print("origin: ", origin)
	var distance = player.global_position.distance_to(origin)
	#print("distance: ", distance)
	new_objective_instance.timer.wait_time = int(distance / 100)
	objectives.add_child(new_objective_instance)

func spawn_enemies() -> void:
	for i in range(world_stats.get_wave_amount()):
		spawn_enemy()

func spawn_enemy() -> void:
	var origin = get_open_cell_position()
	
	var new_enemy_instance = basic_enemy.instance()
	var new_enemy_turret_instance = basic_enemy_turret.instance()
	enemies.add_child(new_enemy_instance)
	
	new_enemy_instance.origin = origin
	new_enemy_instance.global_position = origin
	new_enemy_turret_instance.global_position = origin
	new_enemy_turret_instance.target_path = new_enemy_instance.get_path()
	new_enemy_turret_instance.bullets_path = bullets.get_path()
	enemies_turrets.add_child(new_enemy_turret_instance)
	new_enemy_instance.assign_turret(new_enemy_turret_instance.get_path())
	
