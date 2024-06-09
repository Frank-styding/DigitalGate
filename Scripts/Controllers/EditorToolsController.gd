extends Node

enum Tools {
    insert,
    connect,
    select
}

var mode = null

signal start_tool(mode: Tools);
signal end_tool(mode: Tools);

func set_mode(n_mode: Tools):
    if n_mode == mode:
        return

    end_tool.emit(mode)
    mode = n_mode
    start_tool.emit(n_mode)

func is_tool(n_tool: Tools):
    return n_tool == mode