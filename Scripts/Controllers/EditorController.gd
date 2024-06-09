extends Node

signal create_wire(wire_data: CWire.WireData)
signal update_wire(wire_data: CWire.WireData, idx: int)
signal destroy_wire(wire_data: CWire.WireData, idx: int)

signal update_gate(gate_data: CGate.GateData)
signal create_gate(gate_data: CGate.GateData)
signal destroy_gate(gate_data: CGate.GateData)

var board: Board
var editor: Editor
var gate_preview: GatePreview

func global_position():
    return editor.get_global_mouse_position()

func grid_pos():
    return Vector2(board.get_tile_mose_pos())
