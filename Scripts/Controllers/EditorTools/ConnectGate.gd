extends Node

var tool = EditorToolsController.Tools.connect
func _ready():
    InputController.mouse_click.connect(mouse_click)
    InputController.mouse_move.connect(mouse_move)
    InputController.on_input_update.connect(on_input_update)
    EditorToolsController.start_tool.connect(start)
    EditorToolsController.end_tool.connect(end)

func start(mode):
    if mode != tool:
        return
    
    WireController.on_connect.emit("0", "A")
    WireController.set_path([Vector2(5, 0), Vector2(5, 4), Vector2(5, 4)])
    WireController.on_connect.emit("1", "A")

func end(mode):
    if mode != tool:
        return
    pass

func on_input_update():
    if not is_connect_mode():
        return

    if Input.is_action_pressed("Escape"):
        WireController.cancel_wire()
func is_connect_mode():
    return EditorToolsController.is_tool(tool )
func mouse_move(_event: InputEvent):
    if not is_connect_mode():
        return

    var mouse_grid_pos = EditorController.grid_pos()
    var gloval_mouse_pos = EditorController.global_position()
    WireController.move_point(mouse_grid_pos, gloval_mouse_pos, EditorController.board)
    
    if !WireController.has_current_wire():
        return
    EditorController.update_wire.emit(WireController.current_wire, WireController.current_wire.current_path_idx)

func mouse_click(_event: InputEvent):
    if not is_connect_mode():
        return
    var mouse_grid_pos = EditorController.grid_pos()
    var gloval_mouse_pos = EditorController.global_position()
    WireController.select_wire(gloval_mouse_pos, mouse_grid_pos, EditorController.board)

    if !WireController.has_current_wire():
        return
        
    EditorController.update_wire.emit(WireController.current_wire, WireController.current_wire.current_path_idx)
    WireController.add_point(EditorController.grid_pos())
