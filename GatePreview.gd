extends ColorRect

@export var error_color = Color(0.973,0.027,0.251,0.42)
@export var normal_color = Color(0,0.627,0.371,0.42)
	
func change_to_error():
	self.color = error_color
	
func change_to_normal():
	self.color = normal_color

func init(gate:Classes.GateData):
	if gate == null:
		print("can init preview")
		return
	self.size = gate.grid_size * Gloval.cell_size
	
func _ready():
	self.color = normal_color
