extends ColorRect

class_name GatePreview

var error_color = Colors.insert_error_c
var normal_color = Colors.inser_normal_c
	
func change_to_error():
	self.color = error_color
	
func change_to_normal():
	self.color = normal_color

func init(gate: CGate.GateData):
	if gate == null:
		print("can init preview")
		return
	self.size = gate.grid_size * Global.cell_size
	
func _ready():
	self.color = normal_color
