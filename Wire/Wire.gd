extends Line2D

var wire_data;

@onready var Corner = preload ("res://Wire/Corner.tscn")

var corners = []
func update_points(path):
	var min_size = min(path.size(), points.size())

	for i in range(min_size):
		if points[i].x == path[i].x&&points[i].y == path[i].y:
			continue
		else:
			points[i].x = path[i].x
			points[i].y = path[i].y

	if path.size() > points.size():
		for i in range(points.size(), path.size()):
			add_point(path[i])
		
		if path.size() > 2:
			var n_corner = Corner.instantiate()
			n_corner.position = path[- 2]
			corners.append(n_corner)
			add_child(n_corner)
				
	else:
		for i in range(path.size(), points.size()):
			points.remove_at(i)
			if i - 1 >= 0:
				remove_child(corners[i - 2])
				corners[i - 1].free()
				corners.remove_at(i - 2)
