class_name WorldStats
extends Resource


export var objectives_complete := 0 setget set_objectives_complete
export var deliveries_complete := 0 setget set_deliveries_complete
export var is_active_objective := false setget set_is_active_objective

func save() -> void:
	ResourceSaver.save(resource_path, self)

# Setters

func set_objectives_complete(new_obj: int) -> void:
	objectives_complete = new_obj
	save()

func set_deliveries_complete(new_del: int) -> void:
	deliveries_complete = new_del
	save()

func set_is_active_objective(new_flag: bool) -> void:
	is_active_objective = new_flag
	save()

func get_wave_amount() -> int:
	return 10
