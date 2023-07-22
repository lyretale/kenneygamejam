extends KinematicBody2D

# Will store the robot when it enters the Area2D.
var target: KinematicBody2D

# The Area2D that detects the player.
onready var aggro_area := $AggroArea
onready var neighbor_detector = $NeighborDetector
onready var raycast := $RayCast2D

#var ai_steering := AISteering.new()
var steering = BoidSteering.new()

export var max_speed := 150.0
export var drag_factor := 0.95
export var origin = Vector2.ZERO

var velocity := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var direction := Vector2.ZERO

var health := 100

func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered")
	aggro_area.connect("body_exited", self, "_on_player_exited")

func _physics_process(delta: float) -> void:
	steering.reset()
	steering.velocity = velocity
	steering.move_speed = max_speed
	
	
	var neighbors = neighbor_detector.get_overlapping_bodies()
	neighbors.erase(self)
	steering.apply_separation(global_position, neighbors, 10.0)
	
	
	if target:
		var target_position = target.global_position
		raycast.look_at(target_position)
		raycast.force_raycast_update()
		
		if raycast.get_collider() == target:
			var displacement = target_position - global_position
			var seek_weight = Utils.map_value(displacement.length(), 24, 32)
			steering.apply_seek(displacement.angle(), seek_weight)
			
			if seek_weight > 0:
				steering.apply_seek(velocity.angle(), 0.1)
				
			steering.apply_separation(global_position, [target], 100.0)
			steering.apply_arrival(displacement, 400.0)
	else:
		steering.apply_wander(position, delta)
		steering.apply_origin(position, origin, 6 * 16, 8 * 16)
	
	velocity = move_and_slide(steering.get_new_velocity() * drag_factor)
	position += velocity * delta
	rotation = velocity.angle()
	update()


"""
spawn function does:
	picks random origin
	makes turret



"""

func make_turret() -> void:
	pass

func spawn(location: Vector2) -> void:
	origin = location
	position = location

func die():
	# dead animation 
	queue_free()

func take_damage(damage) -> void:
	health -= damage
	if health <= 0:
		die()
	print("enemy health: ", health)

func _on_player_entered(body: KinematicBody2D) -> void:
	# Sets the target when it enters the Area2D.
	if body.is_in_group("player"):
		target = body


func _on_player_exited(body: KinematicBody2D) -> void:
	# When player exits the Area2D, the target is out of range.
	if body.is_in_group("player"):
		target = null
