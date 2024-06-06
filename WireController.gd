extends Node

var wires = {}
var _start_connection = {
	"gate": "",
	"connection": ""
}
var current_wire: Classes.WireData = null

signal on_create_wire(current_wire);
signal on_update_wire();

func start(gate_id: String, connection: String):
	if current_wire != null:
		return

	current_wire = Classes.WireData.new()
	_start_connection["gate"] = gate_id
	_start_connection["connection"] = connection
	current_wire.start(gate_id, connection)
	on_create_wire.emit(current_wire)

func end(gate_id: String, connection: String):

	if gate_id == _start_connection["gate"]&&connection == _start_connection["connection"]:
		return
	current_wire.end(gate_id, connection)
	wires[current_wire.id] = current_wire
	on_update_wire.emit()
	current_wire = null
	_start_connection = {
		"gate": "",
		"connection": ""
	}

func select_wire(gloval_pos: Vector2, grid_pos: Vector2, board: Board):
	if current_wire != null:
		return
		
	for wire_id in wires:
		if wires[wire_id].gloval_point_is_inside(gloval_pos, board):
			wires[wire_id].start_sub_line(grid_pos)

func update_wire():
	on_update_wire.emit()

func register_wire(wire_data: Classes.WireData):
	wires[wire_data.id] = wire_data
