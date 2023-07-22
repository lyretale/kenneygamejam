extends Resource
class_name Utils
"""
static func map_value(value, min_value : float, max_value : float, will_clamp = true) -> float:
	if max_value > min_value:
		var map = (value - min_value) / (max_value - min_value)
		if will_clamp:
			map = clamp(map, 0.0, 1.0)
		return map
	else:
		return 1.0 if value >= min_value else 0.0
"""
static func map_value(value, min_value : float, max_value : float, \
		istop := 0.0, ostop := 1.0, will_clamp = true) -> float:
	value = range_lerp(value, min_value, max_value, istop, ostop)
	if will_clamp:
		value = clamp(value, istop, ostop)
	return value

static func draw_circle_arc(center, radius, angle_from, angle_to, color, ci : CanvasItem):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	var angle_diff = wrapf(angle_to - angle_from, 0, 2 * PI)
	# Meant to draw a circle if to and from are different but the diff is 0
	if angle_diff == 0 && angle_to != angle_from:
		angle_diff = 2 * PI
	
	for i in range(nb_points + 1):
		var angle_point = angle_diff * i / nb_points + angle_from
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		ci.draw_line(points_arc[index_point], points_arc[index_point + 1], color)
