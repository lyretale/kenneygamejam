extends Resource
class_name BoidSteering

export var move_speed := 4.0 * 16
export var max_force := 16.0

# The steering value that is to be added to velocity every update
var steering := Vector2()
# The velocity of the agent that we'll be steering
var velocity := Vector2()
# The previous non-zero velocity of the agent
var facing := Vector2.RIGHT
# Previous angle of the wandering logic
var wander_theta := rand_range(-PI, PI)
# Max amount of adjust the wander theta per update
var wander_max = PI * 0.1
# Stores data used in debugging
var debug = {}

func reset():
	steering = Vector2()

# Moves towards an angle
# NOTE: It's common to use a position here, but I prefer to use angles,
#		feel free to change to what you want to use
func apply_seek(angle : float, weight := 1.0):
	var desired_velocity = polar2cartesian(1, angle) * move_speed
	steering += (desired_velocity - velocity) * weight

# Move away from an angle
func apply_flee(angle : float, weight := 1.0):
	# Same as seek, but in the opposite direction
	apply_seek(wrapf(angle + PI, -PI, PI), weight)

# Moves away from an array of nodes.
# NOTE: You could pass in nodes detected from an array's get_overlapping_bodies() method
func apply_separation(position : Vector2, neighbors : Array, radius : float):
	# NOTE: For performance reasons I tend to use length_squared() with boids,
	# 		so need to raise checks to the power of two
	var max_distance_sqr = radius * radius
	for neighbor in neighbors:
		if neighbor.global_position == position:
			continue
		var displacement = neighbor.global_position - position
		var distance_sqr = displacement.length_squared()
		if distance_sqr < max_distance_sqr:
			var factor = 1 - (distance_sqr / max_distance_sqr)
			apply_flee(displacement.angle(), 0.5 * factor)

# Applies a brake to slow down the agent as it approaches a position
# Returns the factor used for braking, to check if entity is within distance
func apply_arrival(displacement : Vector2, radius : float, inner_radius := 0.0):
	if is_zero_approx(radius):
		return
	
	var radius_sqr = radius * radius
	var distance_sqr = displacement.length_squared()
	if distance_sqr < radius_sqr:
		var factor = Utils.map_value(distance_sqr, inner_radius * inner_radius, radius_sqr)
		# NOTE: Not the best braking, this could be improved
		velocity *= factor
		steering *= factor
		return factor
	return 1

func apply_wander(position : Vector2, delta : float, look_ahead_offset := 64.0, offset_radius := 8.0):
	# The origin point to offset the wandering theta
	var look_ahead_point = position + facing * look_ahead_offset
	# Add a random value so that it adjusts gradually
	wander_theta += rand_range(-wander_max, wander_max)
	# Translate the info into a point for the agent to seek towards
	var wander_point = look_ahead_point + polar2cartesian(offset_radius, wander_theta + facing.angle())
	
	apply_seek((wander_point - position).angle(), 0.05)
	
	# Debugging info
	debug.look_ahead_offset = look_ahead_offset
	debug.look_ahead_point = look_ahead_point
	debug.look_ahead_radius = offset_radius
	debug.wander_point = wander_point

# Attempts to keep the boid in a given area
func apply_origin(position : Vector2, origin : Vector2, inner_radius : float, outer_radius : float):
	var displacement = origin - position
	var distance_sqr = displacement.length_squared()
	var factor = Utils.map_value(distance_sqr, inner_radius * inner_radius, outer_radius * outer_radius)
	# If factor > 0 then agent it outside of bounds
	if !is_zero_approx(factor):
		apply_seek(displacement.angle(), factor * 0.05)

# Returns the veocity that the agent should use for movement
func get_new_velocity() -> Vector2:
	# Clamp to adjust how much of an effect steering has on this agent
	# Lower values causes it to change velocity slower
	var _steering = steering.clamped(max_force)
	var _velocity = (velocity + _steering).clamped(move_speed)
	# If we're moving then update the direction we're facing
	if _velocity != Vector2.ZERO:
		facing = _velocity.normalized()
	return _velocity

func debug_draw(ci : CanvasItem):
	if !debug.empty():
		# Draw the wandering debug info
		ci.draw_line(Vector2.ZERO, ci.to_local(debug.look_ahead_point), Color.green)
		Utils.draw_circle_arc(ci.to_local(debug.look_ahead_point), debug.look_ahead_radius, 0, TAU, Color.green, ci)
		ci.draw_circle(ci.to_local(debug.wander_point), 2, Color.red)
