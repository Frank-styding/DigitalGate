extends Node2D

class_name Editor

@onready var board = $Controls/Board
@onready var gate_preview = $Controls/GatePreview
@onready var GateItem = preload ("res://Gate/Gate.tscn")
@onready var Wire = preload ("res://Wire/Wire.tscn")
@onready var WiresContainer = $Wires
@onready var GatesContainer = $Gates

var mouse_grid_pos = Vector2()

var gloval_mouse_pos = Vector2()

func _ready():
	EditorController.board = board
	EditorController.editor = self
	EditorController.gate_preview = gate_preview

	EditorController.create_wire.connect(create_wire)
	EditorController.update_wire.connect(update_wire)
	EditorController.destroy_wire.connect(destroy_wire)
	
	EditorController.create_gate.connect(create_gate)
	EditorController.update_gate.connect(update_gate)
	EditorController.destroy_gate.connect(destroy_gate)
	
	EditorToolsController.set_mode(EditorToolsController.Tools.insert)
	EditorToolsController.set_mode(EditorToolsController.Tools.connect)

var wires = {}
var gates = {}

func create_wire(wire_data: CWire.WireData):
	var wire = Wire.instantiate()
	wire.wire_data = wire_data
	wire.idx = wire_data.current_path_idx
	wires[wire_data.id] = wire
	WiresContainer.add_child(wire)

func update_wire(wire_data: CWire.WireData):
	if wire_data == null:
		return
	var wire = wires[wire_data.id]
	wire.update_points(WireController.get_global_path(board))

func destroy_wire():

	pass

func create_gate(gate_data: CGate.GateData):
	var pos = gate_data.grid_pos
	var gate = GateItem.instantiate()
	gate.position = board.map_to_local(pos) + board.position
	gate.set_gate_data(gate_data)
	gates[gate_data.id] = gate
	GatesContainer.add_child(gate)

func update_gate():
	pass

func destroy_gate():
	pass
