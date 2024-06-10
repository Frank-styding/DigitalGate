extends Line2D

var wire_data;
var idx;

@onready var Corner = preload ("res://Wire/Corner.tscn")

var corners = []

func select():
	var n_color = Color(Colors.select_c)
	n_color.a = 0.3
	default_color = n_color

	for i in range(corners.size()):
		corners[i].set_color(Colors.select_c)

func un_select():
	pass
	default_color = Colors.wire_c
	for i in range(corners.size()):
		corners[i].set_color(Colors.wire_corner_color)

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
		
		if path.size() > 2||idx > 0:
			var n_corner = Corner.instantiate()
			n_corner.position = path[- 2]
			corners.append(n_corner)
			add_child(n_corner)
				
	else:
		for i in range(path.size(), points.size()):
			points.remove_at(i)
			if i - 1 >= 1&&i - 1 < corners.size() - 1:
				remove_child(corners[i - 2])
				corners[i - 1].free()
				corners.remove_at(i - 2)
