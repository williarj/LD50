extends gridmember
class_name square

var A2D : Area2D
var next_path = 0
var pollution = 0 setget set_pollution

signal was_polluted(box)
signal rotated_left(box)
signal rotated_right(box)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.A2D = ($Area2D as Area2D)
	self.paths = $Paths.get_children()

func _on_Area2D_rotate_left():
	var original : int = self.direction
	#self.rotation_degrees = fmod(self.A2D.rotation_degrees - 90, 360)
	self.direction = (self.direction + 3) % 4
	print("%d -> %d" % [original, self.direction])
	emit_signal("rotated_left", self)

func _on_Area2D_rotate_right():
	var original : int = self.direction
	#self.rotation_degrees = fmod(self.A2D.rotation_degrees + 90, 360)
	self.direction = (self.direction + 1) % 4
	print("%d -> %d" % [original, self.direction])
	emit_signal("rotated_right", self)

func set_pollution(new_val):
	pollution = new_val
	$Area2D/box_sprite.modulate = Color(1.0-pollution/10.0, 1.0-pollution/10.0, 1.0-pollution/10.0)
	
func receive_packet(pack):
	self.pollute()
	emit_signal("was_polluted", self)

func pollute():
	self.pollution += 1
	
func connect_to_sound(sound):
	self.connect("was_polluted", sound, "on_pollution")
	self.connect("rotated_left", sound, "on_rotate_right")
	self.connect("rotated_right", sound, "on_rotate_left")
