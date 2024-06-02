@tool
extends Node2D

@onready var GateContection = preload("res://Gate/Connection.tscn")

var gate_data: Classes.GateData;
func _ready():
	if GateController.current_gate == null:
		return
		
	gate_data = GateController.current_gate
	GateController.register_gate(gate_data)
	set_connections();
	calc_size()
	update_name();
	
	
func calc_size():
	var n_width = (gate_data.grid_size.x) * Gloval.cell_size
	var n_height = (gate_data.grid_size.y) * Gloval.cell_size
	$Box.size = Vector2i(n_width,n_height)

func create_conections(list,container_name,horizontal):
	var container = find_child(container_name)
	
	if container is VBoxContainer || container is HBoxContainer:
		container.add_theme_constant_override("separation", Gloval.cell_size/2)
	
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	for i in range(list.size()):
		var item = list[i]
		if gate_data.behavior.connections.has(item):
			var connection = GateContection.instantiate()
			connection.horizontal = horizontal
			connection.type = gate_data.behavior.connections[item]["type"]
			connection.binary_width = gate_data.behavior.connections[item]["width"]
			connection.connection_name = item
			container.add_child(connection)
	
func set_connections():
	create_conections(gate_data.left_co,"Left",false)
	create_conections(gate_data.right_co,"Right",false)
	create_conections(gate_data.top_co,"Top",true)
	create_conections(gate_data.bottom_co,"Bottom",true)

func update_name():
	$Box/Name.text = gate_data.behavior.type

