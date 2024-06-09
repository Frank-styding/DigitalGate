extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var zoom_step = 1.05
var mouse_pos: Vector2 = Vector2(0, 0)

@onready var paralaxBackground = $"../ParallaxBackground"

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				_previousPosition = event.position;
				_moveCamera = true;
			else:
				_moveCamera = false;
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_at_point(zoom_step)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_at_point(1 / zoom_step)
			
	elif event is InputEventMouseMotion&&_moveCamera:
		mouse_pos = event.position
		position += (_previousPosition - event.position) / zoom;
		_previousPosition = event.position;

func zoom_at_point(zoom_change):
	if (zoom * zoom_change).x < 0.37688:
		return
	var point = get_local_mouse_position();
	zoom = zoom * zoom_change;
	var diff = point - get_local_mouse_position()
	offset += diff;
