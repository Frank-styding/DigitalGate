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
	
	var current_point_idx: int
	var current_path_idx: int

	var is_start_path: bool
	var block_direction: bool
	var start_click: bool
	var size: int
	var direction: Vector2
	var is_end: bool
	var last_point: Vector2
	
	func _init():
		current_path_idx = 0
		current_point_idx = -1
		size = 1
		direction = Vector2(0, 0)
		is_start_path = false
		block_direction = true
		start_click = true
		is_end = false
		last_point = Vector2()
		id = Uuid.generate_uuid_v4()

	func is_grid_pos_inside(point: Vector2, exclude_start=false, exclude_last=false, all=true):
		for i in range((0 if exclude_start else 1), paths[current_path_idx].size() + ( - 1 if exclude_last else 0)):
			var prev_p = paths[current_path_idx][i - 1]
			var prev_p1 = paths[current_path_idx][i]
			var distance = prev_p1.distance_to(prev_p);
			var distance1 = point.distance_to(prev_p) + point.distance_to(prev_p1)
			if distance == distance1:
				return true
		
		if paths.size() < 1||!all:
			return false

		for j in range(paths.size() - 1):
			for i in range(paths[j].size()):
				var prev_p = paths[j][i - 1]
				var prev_p1 = paths[j][i]
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
		
		is_start_path = true
		paths.append([
			Vector2(n_point),
			n_point
		])

		last_point = Vector2(n_point)
		current_point_idx = 1

	func start_sub_line(pos: Vector2):
		is_start_path = true
		current_path_idx += 1
		current_point_idx = -1
		paths.append([
			Vector2(pos),
			pos
		])
		last_point = Vector2(pos)
		current_point_idx = 1
	
	func add_point(pos: Vector2, clone=true):
		if not is_start_path:
			return

		if start_click:
			start_click = false
			return
		
		if is_grid_pos_inside(pos, false, true)||(last_point.x == pos.x&&last_point.y == pos.y):
			return
	
		if clone:
			paths[current_path_idx].append(Vector2(pos))
		else:
			paths[current_path_idx].append(pos)
		
		last_point = Vector2(pos)

		block_direction = paths[current_path_idx].size() < 3
		current_point_idx += 1;
	
	func calc_direction(pos: Vector2, gloval_pos: Vector2, board: Board):
		if block_direction:
			return direction

		var current_path = paths[current_path_idx]
		var prev_point_1 = current_path[current_path.size() - 2]
		var n_direction = Vector2()

		if current_path.size() > 2:
			var prev_point = current_path[current_path.size() - 3]
			var v1 = (prev_point - prev_point_1).normalized()
			var v2 = (pos - prev_point_1).normalized()
			var dot = v1.dot(v2)
			var cross = v1.cross(v2)
			if dot < 0:
				n_direction = v1 * - 1
			else:
				if cross > 0:
					n_direction = Vector2( - v1.y, v1.x)
				else:
					n_direction = Vector2(v1.y, -v1.x)
			return n_direction
		if current_path_idx == 0||current_path.size() > 3:
			return direction
		var v3 = (gloval_pos - board.convert_grid_pos(prev_point_1)).normalized()
		if abs(v3.x) > abs(v3.y):
			n_direction = Vector2(v3.x, 0).normalized()
		else:
			n_direction = Vector2(0, v3.y).normalized()

		return n_direction
	
	func move_point(grid_pos: Vector2, gloval_pos: Vector2, board: Board):
		if not is_start_path:
			return

		var current_path = paths[current_path_idx]
		
		direction = calc_direction(grid_pos, gloval_pos, board)
		var prev_point = current_path[current_path.size() - 2]
		var dot = direction.dot(grid_pos - prev_point)
		if dot < 0:
			return
		var n_pos = dot * direction + prev_point
		grid_pos.x = n_pos.x
		grid_pos.y = n_pos.y

		current_path[current_point_idx].x = grid_pos.x
		current_path[current_point_idx].y = grid_pos.y

	func update_point(grid_pos: Vector2):
		paths[current_path_idx][current_point_idx].x = grid_pos.x
		paths[current_path_idx][current_point_idx].y = grid_pos.y
	
	func get_last_direction():
		return (paths[current_path_idx][ - 1] - paths[current_path_idx][ - 2]).normalized()

	func end(gate_id: String, connection: String):
		if not is_start_path:
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
			update_point(n_point)
		else:
			add_point(n_point)
			
		is_end = true
		is_start_path = false
		current_point_idx = -1
		start_click = false
	
	func get_gloval_paths(board: Board):
		var n_paths = []
		for i in range(paths.size()):
			var aux = []
			for j in range(paths[i].size()):
				aux.append(board.convert_grid_pos(paths[i][j]))
			n_paths.append(aux)
		return n_paths

	func get_gloval_current_path(board: Board):
		return get_gloval_paths(board)[current_path_idx]

	func gloval_point_is_inside(point: Vector2, board: Board):
		var gloval_paths = get_gloval_paths(board)

		if Gloval.is_point_inside_paths(gloval_paths, point, Gloval.wire_width / 4.0):
			return true

		return false
