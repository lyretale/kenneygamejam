class_name PlayerStats
extends Resource

export var health := 100 setget set_health
export var gold := 0 setget set_gold
export var boost_speed := 1000.0 setget set_boost_speed
export var normal_speed := 400.0 setget set_normal_speed
export var drag_factor := 0.01 setget set_drag_factor
export var turret_cannon_attack := 20.0 setget set_turret_cannon_attack
export var turret_cooldown := 2.0 setget set_turret_cooldown

func save() -> void:
	ResourceSaver.save(resource_path, self)

# Setters

func set_health(new_health: int) -> void:
	health = new_health
	save()

func set_gold(new_gold: int) -> void:
	gold += new_gold
	save()

func set_turret_cooldown(new_cooldown: float) -> void:
	turret_cooldown = new_cooldown
	save()
	
	# Add code to update UI here
	
	save()

func set_boost_speed(new_boost_speed: float) -> void:
	boost_speed = new_boost_speed
	save()

func set_normal_speed(new_normal_speed: float) -> void:
	normal_speed = new_normal_speed
	save()

func set_drag_factor(new_drag_factor: float) -> void:
	drag_factor = new_drag_factor
	save()
	
func set_turret_cannon_attack(new_attack_power: float) -> void:
	turret_cannon_attack = new_attack_power
	save()
	

		
		
