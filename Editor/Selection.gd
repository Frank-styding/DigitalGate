extends ColorRect
class_name Selection
var start_point
func start(point):
	start_point = point
	position = Vector2(point)

func end(point):
	if start_point == null:
		return
	if point.x - start_point.x <= 0:
		position.x = point.x
		size.x = start_point.x - point.x
	else:
		position.x = start_point.x
		size.x = point.x - start_point.x

	if point.y - start_point.y <= 0:
		position.y = point.y
		size.y = start_point.y - point.y
	else:
		position.y = start_point.y
		size.y = point.y - start_point.y

func cancel():
	start_point = null
	position = Vector2(0, 0)
	size = Vector2(0, 0)
