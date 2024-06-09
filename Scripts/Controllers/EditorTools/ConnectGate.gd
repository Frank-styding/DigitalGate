extends Node

func _ready():
    MouseController.mouse_click.connect(mouse_click)
    MouseController.mouse_move.connect(mouse_move)
    EditorToolsController.start_tool.connect(start)
    EditorToolsController.end_tool.connect(end)

func start(mode):
    if mode != EditorToolsController.Tools.connect:
        return
    pass

func end(mode):
    if mode != EditorToolsController.Tools.connect:
        return
    pass

func mouse_move(_event: InputEvent):
    if not EditorToolsController.is_tool(EditorToolsController.Tools.connect):
        return
    var mouse_grid_pos = EditorController.grid_pos()
    var gloval_mouse_pos = EditorController.global_position()
    WireController.move_point(mouse_grid_pos, gloval_mouse_pos, EditorController.board)
    EditorController.update_wire.emit(WireController.current_wire)

func mouse_click(_event: InputEvent):
    if not EditorToolsController.is_tool(EditorToolsController.Tools.connect):
        return
    var mouse_grid_pos = EditorController.grid_pos()
    var gloval_mouse_pos = EditorController.global_position()
    WireController.select_wire(gloval_mouse_pos, mouse_grid_pos, EditorController.board)
    EditorController.update_wire.emit(WireController.current_wire)
    if !WireController.has_current_wire():
        return
    WireController.add_point(EditorController.grid_pos())
