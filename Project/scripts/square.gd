extends gridmember
class_name square

var A2D : Area2D
var next_path = 0
var pollution = 0 setget set_pollution

# Called when the node enters the scene tree for the first time.
func _ready():
	self.A2D = ($Area2D as Area2D)
	self.paths = $Paths.get_children()

func _on_Area2D_rotate_left():
	self.rotate_left()

func _on_Area2D_rotate_right():
	self.rotate_right()

func set_pollution(new_val):
	pollution = clamp(new_val, 0, 10)
	$Area2D/box_sprite.modulate = Color(1.0-pollution/10.0, 1.0-pollution/10.0, 1.0-pollution/10.0)
	
func packet_stopped(pack):
	match pack.resource_type:
		Globals.Resources.TRIANGE:
			self.pollution -= 1
		_:
			self.pollution += 1

func packet_entered(pack):
	if pack.resource_type == Globals.Resources.TRIANGE:
		self.pollution -= 1

func pollute():
	self.pollution += 1
