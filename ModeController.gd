extends Node

signal close_mode(mode:int)
signal init_mode(mode:int)

var mode = -1

func set_mode(n_mode):
	if mode == n_mode:
		return
	close_mode.emit(mode)
	mode = n_mode
	init_mode.emit(mode)


