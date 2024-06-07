extends Node2D

class_name Editor

@onready var board = $Controls/Board
var mouse_grid_pos = Vector2()

var gloval_mouse_pos = Vector2()

func _ready():
	ModeController.init_mode.connect(init_mode)
	ModeController.close_mode.connect(close_mode)
	WireController.on_create_wire.connect(create_wire)
	WireController.on_update_wire.connect(update_wire)
	WireController.on_clear_current_wire.connect(clear_current_wire)
	ModeController.set_mode(0)
	ModeController.set_mode(1)

func init_mode(mode):
	if mode == 0:
		start_insert()
	
	if mode == 1:
		start_connect()
	pass

func close_mode(mode):
	if mode == 0:
		end_insert()
	
	if mode == 1:
		end_connect()

#region insert controls
@onready var GateItem = load("res://Gate/Gate.tscn")
@onready var GatePreview = $Controls/GatePreview
@onready var GatesContainer = $Gates

var n_gate_data

func start_insert():
	GatePreview.show()
	
	GateController.set_current("And")
	n_gate_data = GateController.new_gate_data()
	GatePreview.init(n_gate_data)
	
	GateController.set_current("Or")
	mouse_insert_gate(Vector2i(0, 0))
	
	GateController.set_current("And")
	n_gate_data = GateController.new_gate_data()
	mouse_insert_gate(Vector2i(0, 4))

func mouse_insert_gate(n_pos=null):
	if not n_gate_data is Classes.GateData:
		return
	var pos = n_pos if n_pos != null else board.get_tile_mose_pos()
	
	n_gate_data.grid_pos.x = pos.x
	n_gate_data.grid_pos.y = pos.y
	
	if GateController.cell_is_emty(n_gate_data):
		var gate = GateItem.instantiate()
		gate.position = board.map_to_local(pos) + board.position
		gate.set_gate_data(n_gate_data)
		GatesContainer.add_child(gate)

func move_gate_preview():
	if not n_gate_data is Classes.GateData:
		return
	var tile_mouse_pos = board.get_tile_mose_pos()
	n_gate_data.grid_pos = tile_mouse_pos
	GatePreview.position = board.map_to_local(tile_mouse_pos) + board.position - Vector2.ONE * Gloval.cell_size / 2
	
	if GateController.cell_is_emty(n_gate_data):
		GatePreview.change_to_normal()
	else:
		GatePreview.change_to_error()

func end_insert():
	GatePreview.hide()
	n_gate_data = null
#endregion
#region connect controls

@onready var WiresContainer = $Wires
@onready var Wire = preload ("res://Wire/Wire.tscn")

var wire = null
	
func create_wire(n_wire_data: Classes.WireData):
	wire = Wire.instantiate()
	wire.wire_data = n_wire_data
	wire.idx = n_wire_data.current_path_idx
	WiresContainer.add_child(wire)

func update_wire():
	if wire == null||WireController.current_wire == null:
		return
	wire.update_points(WireController.current_wire.get_gloval_current_path(board))

func clear_current_wire():
	wire = null

func start_connect():
	pass

func end_connect():
	pass
	
func connect_move_mouse():
	if WireController.current_wire == null||wire == null:
		return

	WireController.current_wire.move_point(mouse_grid_pos, gloval_mouse_pos, board)
	WireController.update_wire()
	
func connect_mouse_down():
	WireController.select_wire(gloval_mouse_pos, mouse_grid_pos, board)
	WireController.update_wire()
	if WireController.current_wire == null:
		return
	WireController.current_wire.add_point(mouse_grid_pos)
#endregion
#region mouse controls
func mouse_move():
	if ModeController.mode == 0:
		move_gate_preview()
	if ModeController.mode == 1:
		connect_move_mouse()

func mouse_pressed():
	pass

var click = true

func mouse_click():
	if ModeController.mode == 0:
		mouse_insert_gate()
	if ModeController.mode == 1:
		connect_mouse_down()

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				mouse_pressed()
				if click:
					mouse_click()
					click = false
			else:
				click = true

	elif event is InputEventMouseMotion:
		mouse_grid_pos = Vector2(board.get_tile_mose_pos())
		gloval_mouse_pos = get_global_mouse_position()
		mouse_move()

#endregion
