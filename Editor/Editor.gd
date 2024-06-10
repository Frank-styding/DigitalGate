extends Node2D

class_name Editor

@onready var board = $Controls/Board
@onready var gate_preview = $Controls/GatePreview
@onready var GateItem = preload ("res://Gate/Gate.tscn")
@onready var Wire = preload ("res://Wire/Wire.tscn")
@onready var WiresContainer = $Wires
@onready var GatesContainer = $Gates
@onready var _selection = $Controls/Selection

var mouse_grid_pos = Vector2()

var gloval_mouse_pos = Vector2()

func _ready():
	EditorController.board = board
	EditorController.editor = self
	EditorController.gate_preview = gate_preview
	EditorController.selection = _selection

	EditorController.create_wire.connect(create_wire)
	EditorController.update_wire.connect(update_wire)
	EditorController.destroy_wire.connect(destroy_wire)
	
	EditorController.create_gate.connect(create_gate)
	EditorController.update_gate.connect(update_gate)
	EditorController.destroy_gate.connect(destroy_gate)
	
	EditorToolsController.set_mode(EditorToolsController.Tools.insert)
	EditorToolsController.set_mode(EditorToolsController.Tools.connect)
	EditorToolsController.set_mode(EditorToolsController.Tools.select)

var wires = {}
var gates = {}

func create_wire(wire_data: CWire.WireData):
	var wire = Wire.instantiate()
	wire.wire_data = wire_data
	wire.idx = wire_data.current_path_idx
	wires[wire_data.id + ":" + str(wire.idx)] = wire
	WiresContainer.add_child(wire)

func update_wire(wire_data: CWire.WireData, idx: int):
	if wire_data == null:
		return
	var wire = wires[wire_data.id + ":" + str(idx)]
	wire.update_points(WireController.get_global_path(board))
	
	if wire_data.selected:
		wire.select()
	else:
		wire.un_select()

func destroy_wire(wire_data: CWire.WireData, idx: int):
	var wire = wires[wire_data.id + ":" + str(idx)]
	if wire != null:
		WiresContainer.remove_child(wire)
		wire.free()

func create_gate(gate_data: CGate.GateData):
	var pos = gate_data.grid_pos
	var gate = GateItem.instantiate()
	gate.position = board.map_to_local(pos) + board.position
	gate.set_gate_data(gate_data)
	gates[gate_data.id] = gate
	GatesContainer.add_child(gate)

func update_gate(gate_data: CGate.GateData):
	if gate_data == null:
		return
	var gate = gates[gate_data.id]
	if gate_data.selected:
		gate.select()
	else:
		gate.un_select()
	pass

func destroy_gate():
	pass
