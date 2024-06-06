@tool
extends CenterContainer
class_name GateConnection;

var stylebox = StyleBoxFlat.new()

@export var color = Gloval.output_color:
	set(n_color):
		stylebox.bg_color = n_color
		color = n_color
		#$Panel.add_theme_stylebox_override("panel", stylebox)
@export var n_size: Vector2 = Vector2(10, 10):
	set(n_size1):
		n_size = n_size1
		#$Panel.custom_minimum_size = n_size;
@export var radius: int = 0:
	set(n_radius):
		radius = n_radius
		stylebox.corner_radius_bottom_left = n_radius
		stylebox.corner_radius_bottom_right = n_radius
		stylebox.corner_radius_top_right = n_radius
		stylebox.corner_radius_top_left = n_radius
		#$Panel.add_theme_stylebox_override("panel", stylebox)

var horizontal = true
var binary_width = 1
var type = 0
var connection_name = ""
var gate_id = ""

@onready var panel = $Panel

func _ready():
	stylebox.bg_color = Gloval.input_color if type == 0 else Gloval.output_color
	stylebox.corner_radius_bottom_left = radius
	stylebox.corner_radius_bottom_right = radius
	stylebox.corner_radius_top_right = radius
	stylebox.corner_radius_top_left = radius
	if horizontal:
		panel.custom_minimum_size = n_size
	else:
		panel.custom_minimum_size = Vector2(n_size.y, n_size.x)
	panel.add_theme_stylebox_override("panel", stylebox)

var mouse_is_over = false
var click = true

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT&&mouse_is_over:
			if event.is_pressed():
				if click:
					WireController.start(gate_id, connection_name)
					WireController.end(gate_id, connection_name)
					click = false
			else:
				click = true
			
func _on_panel_mouse_entered():
	mouse_is_over = true

func _on_panel_mouse_exited():
	mouse_is_over = false
