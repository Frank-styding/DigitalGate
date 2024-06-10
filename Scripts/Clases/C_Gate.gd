extends Node

class GateBehavior:
	var code: String = ""
	var type: String = ""
	
	var connections = {}
	
	func _init(n_code, n_type, n_connections={}):
		self.code = n_code
		self.type = n_type
		self.connections = n_connections
	
	func add_connection(n_name, n_type, width=1):
		self.connections[n_name] = {
			"n_type": n_type,
			"width": width,
			"value": 0
		}

class GateData:
	static var gate_count = -1
	var behavior: GateBehavior
	var left_co = []
	var right_co = []
	var top_co = []
	var bottom_co = []
	
	var grid_pos = Vector2i(0, 0)
	var grid_size = Vector2i(0, 0)
	var selected: bool
	var id;
	
	func _init(n_behavior, left=[], right=[], top=[], bottom=[]):
		gate_count += 1
		self.behavior = n_behavior
		self.left_co = left
		self.right_co = right
		self.top_co = top
		self.bottom_co = bottom
		self.id = str(gate_count)
		self.selected = false
		
		if left.size() == 0&&right.size() == 0&&top.size() == 0&&bottom.size() == 0:
			for con_name in n_behavior.connections.keys():
				var con = n_behavior.connections[con_name]
				if con["type"] == 0:
					right_co.append(con_name)
				if con["type"] == 1:
					left_co.append(con_name)
					
		calc_size()

	func calc_size():
		var max_w_count = max(top_co.size(), bottom_co.size(), 1);
		var max_h_count = max(left_co.size(), right_co.size(), 1);
		grid_size = Vector2i(max_w_count, max_h_count)
	
	func _rotate():
		var aux1 = left_co
		var aux2 = right_co
		var aux3 = top_co
		var aux4 = bottom_co
		
		left_co = aux4
		top_co = aux1
		right_co = aux3
		bottom_co = aux2
	
	func _rotate_in():
		var aux1 = left_co
		var aux2 = right_co
		var aux3 = top_co
		var aux4 = bottom_co
		
		left_co = aux3
		top_co = aux2
		right_co = aux4
		bottom_co = aux1
		
	func get_conection_pos(connection: String):

		var n_pos = Vector2()
		
		var space = 10.0

		if left_co.has(connection):
			n_pos.y = left_co.find(connection) + grid_pos.y
			n_pos.x = grid_pos.x - space / Global.cell_size - 0.5
			
		if right_co.has(connection):
			n_pos.y = right_co.find(connection) + grid_pos.y
			n_pos.x = grid_pos.x + grid_size.x + space / Global.cell_size - 0.5
		
		if top_co.has(connection):
			n_pos.x = top_co.find(connection) + grid_pos.x
			n_pos.y = grid_pos.y - space / Global.cell_size - 0.5
		
		if bottom_co.has(connection):
			n_pos.x = bottom_co.find(connection) + grid_pos.x
			n_pos.y = grid_pos.y + grid_size.y + space / Global.cell_size - 0.5

		return n_pos
	
	func get_connection_direction(connection: String):
		if left_co.has(connection):
			return Vector2( - 1, 0)
		if right_co.has(connection):
			return Vector2(1, 0)
		if top_co.has(connection):
			return Vector2(0, -1)
		if bottom_co.has(connection):
			return Vector2(0, 1)
