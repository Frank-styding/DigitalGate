extends Node
var input_color = Color(0, 0.4771, 0.5192, 1)
var output_color = Color(0.6043, 0.4315, 0.0459, 1);
var cell_size = 64;
var wire_width = 20;

func is_point_inside_path(path, point: Vector2, max_distance):
	for i in range(path.size()):
		var prev_p = path[i - 1]
		var prev_p1 = path[i]
		var d = prev_p1.distance_to(prev_p)
		var a = abs((prev_p1 - prev_p).cross(point - prev_p))
		var dot = (prev_p1 - prev_p).normalized().dot(point - prev_p)
		var h = a / (2 * d)
		if h < max_distance&&0 <= dot&&dot <= d:
			return true
	return false

func is_point_inside_paths(paths, point: Vector2, max_distance):
	for i in range(paths.size()):
		if (is_point_inside_path(paths[i], point, max_distance)):
			return true
	return false
