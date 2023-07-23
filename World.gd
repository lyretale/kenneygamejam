extends Node2D


export var world_stats: Resource = null
export var player_stats: Resource = null
#onready var time_elapsed := 0.0
onready var world_clock = $WorldClock
onready var enemies = $Level/Enemies
onready var enemies_turrets = $Level/EnemiesTurrets
onready var bullets = $Bullets
onready var water_tiles = $Level/Tilemap/TileMapWater
onready var objectives = $Level/Objectives
onready var player = $Level/Player
onready var health_bar = $Level/Player/Camera2D/CanvasLayer/HealthBar/Bar
onready var health_label = $Level/Player/Camera2D/CanvasLayer/HealthBar/Label
onready var time_bar = $Level/Player/Camera2D/CanvasLayer/TimeBar/Bar
onready var time_label = $Level/Player/Camera2D/CanvasLayer/TimeBar/Label
onready var score_label = $Level/Player/Camera2D/CanvasLayer/ScoreBar/HBoxContainer/Score
onready var game_label = $Level/Player/Camera2D/CanvasLayer/GameOver
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
	world_stats.is_active_objective = false
	player_stats.health = 100
	world_clock.connect("timeout", self, "check_active_objective")
	player.connect("update_health", self, "update_health_bar")
	player.connect("end_game", self, "end_game")
	randomize()
	spawn_enemies()

func end_game() -> void:
	game_label.visible = true
	get_tree().paused = true
	pause_mode = PAUSE_MODE_STOP

func update_health_bar() -> void:
	var new_health = player_stats.health
	health_bar.value = new_health
	health_label.text = str(new_health)

func update_time_bar(new_time) -> void:
	time_bar.value = new_time
	time_label.text = str(new_time)

func update_score_bar(new_score) -> void:
	score_label.text = str(new_score)

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
	objectives.add_child(new_objective_instance)
	var objective_time = int(distance / 100)
	print(objective_time)
	time_bar.max_value = objective_time
	time_bar.value = objective_time
	new_objective_instance.set_time(objective_time)
	new_objective_instance.set_player_stats(player_stats)
	new_objective_instance.connect("update_score_objective", self, "update_score_bar")
	new_objective_instance.connect("update_time", self, "update_time_bar")
	player.set_current_objective(origin)

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
	new_enemy_instance.set_player_stats(player_stats)
	new_enemy_instance.connect("update_score_enemy", self, "update_score_bar")
	
