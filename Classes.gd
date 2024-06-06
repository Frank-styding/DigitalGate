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
	var behavior: GateBehavior
	var left_co = []
	var right_co = []
	var top_co = []
	var bottom_co = []
	
	var grid_pos = Vector2i(0, 0)
	var grid_size = Vector2i(0, 0)
	
	var id;
	
	func _init(n_behavior, left=[], right=[], top=[], bottom=[]):
		self.behavior = n_behavior
		self.left_co = left
		self.right_co = right
		self.top_co = top
		self.bottom_co = bottom
		self.id = Uuid.generate_uuid_v4()
		
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
			n_pos.x = grid_pos.x - space / Gloval.cell_size - 0.5
			
		if right_co.has(connection):
			n_pos.y = right_co.find(connection) + grid_pos.y
			n_pos.x = grid_pos.x + grid_size.x + space / Gloval.cell_size - 0.5
		
		if top_co.has(connection):
			n_pos.x = top_co.find(connection) + grid_pos.x
			n_pos.y = grid_pos.y - space / Gloval.cell_size - 0.5
		
		if bottom_co.has(connection):
			n_pos.x = bottom_co.find(connection) + grid_pos.x
			n_pos.y = grid_pos.y + grid_size.y + space / Gloval.cell_size - 0.5

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

class WireData:
	var paths = []
	var input = {}
	var outputs = []
	
	var id: String = ""
	
	var current_point: int
	var current_path: int
	var start_path
	var block_direction
	var start_click
	var size: int
	var direction: Vector2
	var is_end
	
	func _init():
		paths.append([])
		current_path = 0
		current_point = -1
		size = 1
		direction = Vector2(0, 0)
		start_path = false
		block_direction = true
		start_click = true
		is_end = false
		id = Uuid.generate_uuid_v4()

	func is_grid_pos_inside(point: Vector2, last=true):
		for i in range(1, paths[current_path].size() + (0 if last else - 1)):
			var prev_p = paths[current_path][i - 1]
			var prev_p1 = paths[current_path][i]
			var distance = prev_p1.distance_to(prev_p);
			var distance1 = point.distance_to(prev_p) + point.distance_to(prev_p1)
			if distance == distance1:
				return true
		return false
	
	func start(gate_id: String, connection: String):
		var gate = GateController.get_gate_data(gate_id) as GateData
		if gate == null:
			return
			
		input["gate"] = gate_id
		input["connection"] = connection

		var n_point = gate.get_conection_pos(connection)
		direction = gate.get_connection_direction(connection)
		
		start_path = true
		add_point(n_point)
		add_point(n_point, false)

	func start_sub_line(pos: Vector2):
		start_path = true
		current_path += 1
		add_point(pos)
		add_point(pos)
	
	func add_point(pos: Vector2, clone=true):

		if not start_path:
			return

		if start_click:
			start_click = false
			return

		if is_grid_pos_inside(pos, false):
			return
	
		if clone:
			paths[current_path].append(Vector2(pos))
		else:
			paths[current_path].append(pos)

		block_direction = paths[current_path].size() < 3

		current_point += 1;
	
	func move_point(pos: Vector2):
		if not start_path:
			return
		
		var prev_point = paths[current_path][paths[current_path].size() - 2]

		if not block_direction:
			var prev_point_1 = paths[current_path][paths[current_path].size() - 3]
			var n_direction = Vector2()

			var v1: Vector2 = (prev_point - prev_point_1).normalized()
			var v2 = (pos - prev_point).normalized()
			var dot1 = v1.dot(v2)
			var cross = v1.cross(v2)
			if dot1 > 0:
				n_direction = v1
			else:
				if cross > 0:
					n_direction = Vector2( - v1.y, v1.x)
				else:
					n_direction = Vector2(v1.y, -v1.x)
			direction = n_direction
		
		var dot = direction.dot(pos - prev_point)
		if dot < 0:
			return
		var n_pos = dot * direction + prev_point
		pos.x = n_pos.x
		pos.y = n_pos.y

		paths[current_path][current_point].x = pos.x
		paths[current_path][current_point].y = pos.y
	
	func get_last_direction():
		return (paths[current_path][ - 1] - paths[current_path][ - 2]).normalized()

	func end(gate_id: String, connection: String):
		if not start_path:
			return
			
		var gate = GateController.get_gate_data(gate_id) as GateData
		if gate == null:
			return
			
		if input["gate"] == gate_id&&input["connection"] == connection:
			return
		
		outputs.append({
			"gate": gate_id,
			"connection": connection
		})

		var n_point = gate.get_conection_pos(connection)
		var n_direction = gate.get_connection_direction(connection)

		if n_direction.dot(direction) != 0:
			move_point(n_point)
		else:
			add_point(n_point)
		is_end = true
		start_path = false
		current_point = -1
	
	func get_gloval_paths(board: Board):
		var n_paths = []
		for i in range(paths.size()):
			var aux = []
			for j in range(paths[i].size()):
				aux.append(board.convert_grid_pos(paths[i][j]))
			n_paths.append(aux)
		return n_paths

	func get_gloval_current_path(board: Board):
		return get_gloval_paths(board)[current_path]

	func gloval_point_is_inside(point: Vector2, board: Board):
		var gloval_paths = get_gloval_paths(board)

		if Gloval.is_point_inside_paths(gloval_paths, point, Gloval.wire_width / 4.0):
			return true

		return false