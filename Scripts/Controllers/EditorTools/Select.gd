extends Node

var tool = EditorToolsController.Tools.select
func _ready():
    InputController.mouse_click.connect(mouse_click)
    InputController.mouse_move.connect(mouse_move)
    InputController.mosue_up.connect(mouse_up)
    InputController.mouse_down.connect(mouse_down)

    EditorToolsController.start_tool.connect(start)
    EditorToolsController.end_tool.connect(end)

var start_point: Vector2
var is_mouse_down: bool
func start(mode):
    if mode != tool:
        return
    
    for i in GateController.gates_data:
        var gate = GateController.gates_data[i]
        gate.selected = true
        EditorController.update_gate.emit(gate)
    
    for i in WireController.wires_data:
        var wire = WireController.wires_data[i]
        wire.selected = true
        EditorController.update_wire.emit(wire, wire.current_path_idx)

func end(mode):
    if mode != tool:
        return

func is_select_mode():
    return EditorToolsController.is_tool(tool )

func mouse_move(_event: InputEvent):
    if not is_select_mode():
        return
    
    if is_mouse_down:
        EditorController.selection.end(EditorController.global_position())
    
func mouse_down(_event: InputEvent):
    is_mouse_down = true
    start_point = EditorController.global_position()
    EditorController.selection.start(start_point)
    EditorController.selection.end(EditorController.global_position())
    EditorController.selection.show()

func mouse_up(_event: InputEvent):
    is_mouse_down = false
    EditorController.selection.hide()
    EditorController.selection.cancel()

func mouse_click(_event: InputEvent):
    if not is_select_mode():
        return
