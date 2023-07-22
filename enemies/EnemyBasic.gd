extends KinematicBody2D

# Will store the robot when it enters the Area2D.
var target: KinematicBody2D

# The Area2D that detects the player.
onready var aggro_area := $AggroArea
onready var neighbor_detector = $NeighborDetector

#var ai_steering := AISteering.new()
var steering = BoidSteering.new()

export var max_speed := 400.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var direction := Vector2.ZERO


func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered")
	aggro_area.connect("body_exited", self, "_on_player_exited")

func _physics_process(delta: float) -> void:
	if not target:
		steering.reset()
		steering.velocity = velocity
		steering.move_speed = max_speed
		
		steering.apply_wander(position, delta)
		steering.apply_origin(position, Vector2.ZERO, 6 * 16, 8 * 16)
		
		velocity = steering.get_new_velocity()
		position += velocity * delta
		
		update()
	else:
		var target_position = target.global_position
		var displacement = target_position - global_position
		
		var seek_weight = Utils.map_value(displacement.length(), 24, 32)
		var neighbors = neighbor_detector.get_overlapping_bodies()
		neighbors.erase(self)
		steering.reset()
		steering.apply_seek(displacement.angle(), seek_weight)
		
		if seek_weight > 0:
			steering.apply_seek(velocity.angle(), 0.1)
			
		#steering.apply_separation(global_position, neighbors, 12.0)
		
		velocity = steering.get_new_velocity()
		
		position += velocity * delta
		update()
	
	#direction = Vector2(0,0)
	#if target:
	#	target.global_position
		
	#var target_position = get_global_mouse_position()
	#var displacement = target_position - global_position
	
	# Used to determine what we should push away from
	#var neighbors = neighbor_detector.get_overlapping_bodies()
	#neighbors.erase(self)
	
	#var seek_weight = Utils.map_value(displacement.length(), 24, 32)
	
	# Needs to be cleared at the start to reset data from last frame
	#ai_steering.clear()
	# Avoid walls
	#ai_steering.apply_collision_avoidance(self, 12.0)
	# Move towards target
	#ai_steering.apply_seek(displacement.angle(), seek_weight)
	# Use a bias if seeking so we prefer our current direction
	#if seek_weight > 0:
	#	ai_steering.apply_seek(velocity.angle(), 0.1)
	# Move away from nearby entities
	#ai_steering.apply_separation(global_position, neighbors, 12.0)
	
	# Get the direction we want to move
	#var normal = ai_steering.get_desired_normal()
	#var desired_velocity = normal * max_speed
	
	#velocity = velocity.linear_interpolate(desired_velocity, 0.3)
	
	#velocity = move_and_slide(velocity)
	
	
	#rotation = velocity.angle()
	

func _draw():
	steering.debug_draw(self)


func _on_player_entered(body: KinematicBody2D) -> void:
	# Sets the target when it enters the Area2D.
	if body.is_in_group("player"):
		target = body


func _on_player_exited(body: KinematicBody2D) -> void:
	# When player exits the Area2D, the target is out of range.
	if body.is_in_group("player"):
		target = null
