extends TileMap

class_name Board

# Called when the node enters the scene tree for the first time.
func _ready():
	GateController.set_current("And")




func _input(event: InputEvent):
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			var position = get_local_mouse_position()
			var tile_mouse_pos = local_to_map(position)
			var n_gate = GateController.new_gate(tile_mouse_pos)
			
			if n_gate is Classes.GateData:
				if GateController.cell_is_emty(n_gate):
					set_cell(0,tile_mouse_pos,2,Vector2i(0,0),2)
