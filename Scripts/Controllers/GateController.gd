extends Node

#region init behavior
var and_data = CGate.GateBehavior.new(
	"A&B",
	"And",
	{
		"A":{
			"type": 0,
			"width": 1,
			"value": 0,
		},
		"B":{
			"type": 0,
			"width": 1,
			"value": 0,
		},
		"C":{
			"type": 1,
			"width": 1,
			"value": 0,
		}
	}
)

var or_data = CGate.GateBehavior.new(
	"A&B",
	"Or",
	{
		"A":{
			"type": 0,
			"width": 1,
			"value": 0,
		},
		"B":{
			"type": 0,
			"width": 1,
			"value": 0,
		},
		"C":{
			"type": 1,
			"width": 1,
			"value": 0,
		}
	}
)

#endregion

var behavior_data: Dictionary = {"And": and_data, "Or": or_data}
var current_behavior: CGate.GateBehavior = null
var current_gate_data: CGate.GateData = null
var gates_data = {};
var grid = {}

func register_behavior(data: CGate.GateBehavior):
	behavior_data[data.gate_name] = data

func set_current(n_name: String):
	if behavior_data.has(n_name):
		current_behavior = behavior_data[n_name]

func new_gate_data():
	if current_behavior == null:
		return null
	current_gate_data = CGate.GateData.new(current_behavior)
	return current_gate_data

func register_gate_data(gate_data):
	gates_data[gate_data.id] = gate_data
	var x = gate_data.grid_pos.x
	var y = gate_data.grid_pos.y
	var size_x = gate_data.grid_size.x
	var size_y = gate_data.grid_size.y
	grid["%d:%d" % [x, y]] = gate_data.id
	
	for i in range(size_x):
		for j in range(size_y):
			grid["%d:%d" % [x + i, y + j]] = gate_data.id
	
	if gate_data.left_co:
		for j in range(size_y):
			grid["%d:%d" % [x - 1, y + j]] = ""
			grid["%d:%d" % [x - 2, y + j]] = ""
	
	if gate_data.right_co:
		for j in range(size_y):
			grid["%d:%d" % [x + size_x, y + j]] = ""
			grid["%d:%d" % [x + size_x + 1, y + j]] = ""
	
	if gate_data.top_co:
		for i in range(size_x):
			grid["%d:%d" % [x + i, y - 1]] = ""
			grid["%d:%d" % [x + i, y - 2]] = ""
			
	if gate_data.bottom_co:
		for i in range(gate_data.grid_size.x):
			grid["%d:%d" % [x + i, y + size_y]] = ""
			grid["%d:%d" % [x + i, y + size_y + 1]] = ""

func cell_is_emty(gate: CGate.GateData):
	for i in range(gate.grid_size.x):
		for j in range(gate.grid_size.y):
			var key = "%d:%d" % [gate.grid_pos.x + i, gate.grid_pos.y + j]
			if grid.has(key):
				return false
	return true

func get_gate_data(gate_id: String):
	if not gates_data.has(gate_id):
		return null
	return gates_data[gate_id]
