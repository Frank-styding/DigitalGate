extends CenterContainer
class_name GateConnection;

var stylebox = StyleBoxFlat.new()

var color = Colors.output_c
var n_size: Vector2 = Vector2(33, 10)
var radius: int = 6

var horizontal = true
var binary_width = 1
var type = 0
var connection_name = ""
var gate_id = ""

@onready var panel = $Panel

func _ready():
	stylebox.bg_color = Colors.output_c if type == 0 else Colors.input_c
	stylebox.corner_radius_bottom_left = radius
	stylebox.corner_radius_bottom_right = radius
	stylebox.corner_radius_top_right = radius
	stylebox.corner_radius_top_left = radius
	if horizontal:
		panel.custom_minimum_size = n_size
	else:
		panel.custom_minimum_size = Vector2(n_size.y, n_size.x)
	panel.add_theme_stylebox_override("panel", stylebox)
	WireController.on_connect.connect(on_connect)

var mouse_is_over = false
var click = true

func on_connect(n_gate_id: String, n_connection: String):
	if gate_id != n_gate_id||n_connection != connection_name:
		return

	WireController.start(gate_id, connection_name)
	WireController.set_end(gate_id, connection_name)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT&&mouse_is_over:
			if event.is_pressed():
				if click:
					WireController.start(gate_id, connection_name)
					WireController.end(gate_id, connection_name)
					if WireController.current_wire == null:
						get_tree().get_root().set_input_as_handled()
					click = false
			else:
				click = true
			
func _on_panel_mouse_entered():
	mouse_is_over = true

func _on_panel_mouse_exited():
	mouse_is_over = false
