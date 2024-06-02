extends Node

var and_data = Classes.GateBehavior.new(
	"A&B",
	"And",
	{
		"A":{
			"type":0,
			"width":1,
			"value":0,
		},
		"B":{
			"type":0,
			"width":1,
			"value":0,
		},
		"C":{
			"type":1,
			"width":1,
			"value":0,
		}
	}
)

var behavior_data:Dictionary = { "And": and_data }
var current_behavior: Classes.GateBehavior = null
var current_gate: Classes.GateData = null


func register_behavior(data: Classes.GateBehavior):
	behavior_data[data.gate_name] = data


func set_current(name:String):
	if behavior_data.has(name):
		current_behavior = behavior_data[name]
		
func new_gate(pos:Vector2i):
	if current_behavior == null:
		return null
	current_gate = Classes.GateData.new(current_behavior)
	current_gate.grid_pos = pos
	return current_gate


var list_gates = {};
var grid = {}

func register_gate(gate:Classes.GateData):
	list_gates[gate.id] = gate
	grid["%d:%d" % [gate.grid_pos.x,gate.grid_pos.y]] = gate.id
	
	
	for i in range(gate.grid_size.x):
		for j in range(gate.grid_size.y):
			grid["%d:%d" % [gate.grid_pos.x+i,gate.grid_pos.y+j]] = gate.id
	
	if gate.left_co:
		for j in range(gate.grid_size.y):
			grid["%d:%d" % [gate.grid_pos.x - 1,gate.grid_pos.y+j]] = "c::"+gate.id
	
	if gate.right_co:
		for j in range(gate.grid_size.y):
			grid["%d:%d" % [gate.grid_pos.x + gate.grid_size.x ,gate.grid_pos.y+j]] = "c::"+gate.id
	
	if gate.top_co:
		for i in range(gate.grid_size.x):
			grid["%d:%d" % [gate.grid_pos.x + i ,gate.grid_pos.y - 1]] = "c::"+gate.id
	
	if gate.bottom_co:
		for i in range(gate.grid_size.x):
			grid["%d:%d" % [gate.grid_pos.x + i ,gate.grid_pos.y+gate.grid_size.y]] = "c::"+gate.id
	
			
	
func cell_is_emty(gate: Classes.GateData):
	for i in range(gate.grid_size.x):
		for j in range(gate.grid_size.y):
			var key = "%d:%d" % [gate.grid_pos.x +i,gate.grid_pos.y + j]
			if grid.has(key):
				return false
	return true
	
	
