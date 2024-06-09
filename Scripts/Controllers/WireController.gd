extends Node

#signal on_create_wire(current_wire);
#signal on_update_wire();
#signal on_clear_current_wire();

var wires_data = {}
var current_wire: CWire.WireData = null
var start_connection = {"gate": "", "connection": ""}

func start(gate_id: String, connection: String):
	if current_wire != null:
		return

	current_wire = CWire.WireData.new()
	start_connection["gate"] = gate_id
	start_connection["connection"] = connection
	current_wire.start(gate_id, connection)

	EditorController.create_wire.emit(current_wire)

func end(gate_id: String, connection: String):

	if gate_id == start_connection["gate"]&&connection == start_connection["connection"]:
		return

	current_wire.end(gate_id, connection)
	
	wires_data[current_wire.id] = current_wire

	EditorController.update_wire.emit(current_wire)

	current_wire = null
	start_connection = {
		"gate": "",
		"connection": ""
	}

func select_wire(gloval_pos: Vector2, grid_pos: Vector2, board: Board):
	if current_wire != null:
		return
	for wire_id in wires_data:
		if wires_data[wire_id].global_point_is_inside(gloval_pos, board):
			wires_data[wire_id].start_sub_line(grid_pos)
			current_wire = wires_data[wire_id]
			EditorController.create_wire.emit(current_wire)
			
func register_wire(wire_data: CWire.WireData):
	wires_data[wire_data.id] = wire_data

func get_global_path(board: Board):
	if current_wire == null:
		return []
	
	return current_wire.get_global_current_path(board)

func move_point(grid_pos: Vector2, mouse_pos: Vector2, board: Board):
	if current_wire == null:
		return
	current_wire.move_point(grid_pos, mouse_pos, board)
func has_current_wire():
	return current_wire != null

func add_point(grid_pos: Vector2):
	if current_wire == null:
		return
	current_wire.add_point(grid_pos)
