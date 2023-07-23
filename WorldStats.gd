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
	if deliveries_complete == 0:
		return 10
	elif deliveries_complete == 1:
		return 12
	elif deliveries_complete == 2:
		return 18
	elif deliveries_complete == 3:
		return 22
	elif deliveries_complete == 4:
		return 26
	elif deliveries_complete == 5:
		return 30
	elif deliveries_complete == 6:
		return 34
	elif deliveries_complete == 7:
		return 40
	elif deliveries_complete == 8:
		return 44
	elif deliveries_complete == 9:
		return 48
	elif deliveries_complete >= 10:
		return 50
	return 10
