class_name PlayerStats
extends Resource

export var health := 3 setget set_health
export var boost_speed := 1000.0 setget set_boost_speed
export var normal_speed := 400.0 setget set_normal_speed
export var drag_factor := 0.01 setget set_drag_factor

func save() -> void:
	ResourceSaver.save(resource_path, self)

func set_health(new_health: int) -> void:
	health = new_health
	
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
