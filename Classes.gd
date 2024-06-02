extends Node

class GateBehavior:
	var code:String = ""
	var type:String = ""
	
	var connections = {}
	
	func _init(code,type,connections = {}):
		self.code = code
		self.type = type
		self.connections = connections
	
	func add_connection(name,type,width = 1):
		self.connections[name]={ "type": type, "width": width, "value": 0 }

class GateData:
	var behavior: GateBehavior
	var left_co = []
	var right_co = []
	var top_co = []
	var bottom_co = []
	
	var grid_pos = Vector2i(0,0)
	var grid_size = Vector2i(0,0)
	
	var id;
	
	func _init(behavior, left = [], right = [], top = [], bottom = []):
		self.behavior = behavior
		self.left_co  = left
		self.right_co = right
		self.top_co = top
		self.bottom_co = bottom
		self.id = Uuid.generate_uuid_v4()
		
		if left.size() == 0 && right.size() == 0 && top.size() == 0 && bottom.size() == 0:
			for con_name in behavior.connections.keys():
				var con = behavior.connections[con_name]
				if con["type"] == 0:
					left_co.append(con_name)
				if con["type"] == 1:
					right_co.append(con_name)
					
		calc_size()

	func calc_size():
		var max_w_count = max(top_co.size(),bottom_co.size(),1);
		var max_h_count = max(left_co.size(),right_co.size(),1);
		grid_size = Vector2i(max_w_count,max_h_count)
	
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
