extends gridmember
class_name square

var A2D : Area2D
var next_path = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.A2D = ($Area2D as Area2D)
	self.paths = $Paths.get_children()

func _on_Area2D_rotate_left():
	var original : int = self.direction
	#self.rotation_degrees = fmod(self.A2D.rotation_degrees - 90, 360)
	self.direction = (self.direction + 3) % 4
	print("%d -> %d" % [original, self.direction])

func _on_Area2D_rotate_right():
	var original : int = self.direction
	#self.rotation_degrees = fmod(self.A2D.rotation_degrees + 90, 360)
	self.direction = (self.direction + 1) % 4
	print("%d -> %d" % [original, self.direction])


