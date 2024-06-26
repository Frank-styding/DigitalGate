extends Node

signal on_connect(gate_id, conection);

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

	EditorController.update_wire.emit(current_wire, current_wire.current_path_idx)

	current_wire = null
	start_connection = {
		"gate": "",
		"connection": ""
	}

func set_end(gate_id: String, connection: String):

	if gate_id == start_connection["gate"]&&connection == start_connection["connection"]:
		return
    
	current_wire.set_end(gate_id, connection)
	
	wires_data[current_wire.id] = current_wire

	EditorController.update_wire.emit(current_wire, current_wire.current_path_idx)

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
	
	if wires_data.has(wire_data.id):
		return
	
	wires_data[wire_data.id] = wire_data

func get_global_path(board: Board):
	if current_wire == null:
		return []
	
	return current_wire.get_global_current_path(board)

func move_point(grid_pos: Vector2, mouse_pos: Vector2, board: Board):
	if current_wire == null:
		return
	current_wire.move_point(grid_pos, mouse_pos, board)
	EditorController.update_wire.emit(current_wire, current_wire.current_path_idx)

func set_point(grid_pos: Vector2):
	if current_wire == null:
		return
	current_wire.add_point(grid_pos)
	current_wire.update_point(grid_pos)
	EditorController.update_wire.emit(current_wire, current_wire.current_path_idx)

func has_current_wire():
	return current_wire != null

func add_point(grid_pos: Vector2):
	if current_wire == null:
		return
	current_wire.add_point(grid_pos)

func set_path(path):
	if current_wire == null:
		return

	set_point(path[0])
	for i in range(1, path.size()):
		set_point(path[i])

	#current_wire.set_path(path)

	#EditorController.update_wire.emit(current_wire, current_wire.current_path_idx)

func cancel_wire():
	if current_wire == null:
		return

	EditorController.destroy_wire.emit(current_wire, current_wire.current_path_idx)
	
	if current_wire.current_path_idx > 0:
		current_wire.cancel_current_path()
	else:
		wires_data.erase(current_wire.id)
		
	current_wire = null
