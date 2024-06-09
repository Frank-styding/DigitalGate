extends Node

signal mouse_down(event: InputEvent)
signal mosue_up(event: InputEvent)
signal mouse_click(event: InputEvent)
signal mouse_move(event: InputEvent)

var click = true

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				mouse_down.emit(event)
				if click:
					mouse_click.emit(event)
					click = false
			else:
				click = true
	elif event is InputEventMouseMotion:
		mouse_move.emit(event)
