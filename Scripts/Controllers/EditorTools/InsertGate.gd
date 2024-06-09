extends Node

var tool_name = EditorToolsController.Tools.insert
func _ready():
	InputController.mouse_click.connect(mouse_click)
	InputController.mouse_move.connect(mouse_move)
	EditorToolsController.start_tool.connect(start)
	EditorToolsController.end_tool.connect(end)

var n_gate_data;
func start(mode):
	if mode != EditorToolsController.Tools.insert:
		return

	EditorController.gate_preview.show()
	GateController.set_current("Or")
	n_gate_data = GateController.new_gate_data()
	
	GateController.set_current("And")
	n_gate_data = GateController.new_gate_data()
	EditorController.gate_preview.init(n_gate_data)
	GateController.set_current("Or")

	mouse_insert_gate(Vector2i(0, 0))
	
	GateController.set_current("And")
	n_gate_data = GateController.new_gate_data()
	mouse_insert_gate(Vector2i(0, 4))

	pass

func end(mode):
	if mode != EditorToolsController.Tools.insert:
		return
	EditorController.gate_preview.hide()
	pass

func mouse_insert_gate(n_pos=null):
	if not n_gate_data is CGate.GateData:
		return

	var pos = n_pos if n_pos != null else EditorController.board.get_tile_mose_pos()
	
	n_gate_data.grid_pos.x = pos.x
	n_gate_data.grid_pos.y = pos.y
	
	if GateController.cell_is_emty(n_gate_data):
		EditorController.create_gate.emit(n_gate_data)

func mouse_move(_event: InputEvent):

	if not EditorToolsController.is_tool(tool_name):
		return

	var grid_pos = EditorController.grid_pos()
	n_gate_data.grid_pos = grid_pos
	EditorController.gate_preview.position = EditorController.board.convert_grid_pos(grid_pos) - Vector2.ONE * Global.cell_size / 2

	if GateController.cell_is_emty(n_gate_data):
		EditorController.gate_preview.change_to_normal()
	else:
		EditorController.gate_preview.change_to_error()

func mouse_click(_event: InputEvent):
	if not EditorToolsController.is_tool(tool_name):
		return
	
	mouse_insert_gate()
