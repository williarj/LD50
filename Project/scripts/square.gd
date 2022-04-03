extends gridmember
class_name square

var A2D : Area2D
var next_path = 0
var pollution : float = 0.0 setget set_pollution

var pollution_mult = 0.5
var spread = 0.25

signal was_polluted(box)
signal rotated_left(box)
signal rotated_right(box)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.A2D = ($Area2D as Area2D)
	self.paths = $Paths.get_children()
	self.add_to_group("tiles")

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
			self.pollute()

func packet_entered(pack):
	if pack.resource_type == Globals.Resources.TRIANGE:
		self.pollution -= 1

func pollute():
	emit_signal("was_polluted", self)
	self.pollution += (self.pollution_mult)
	for neighbor in self.neighbors:
		if neighbor != null and neighbor.get_class() == "square":
			neighbor.pollution += (spread * self.pollution_mult)

func get_class():
	return "square"

func increase_pollution_mult(by):
	self.pollution_mult += by

func connect_to_sound(sound):
	self.connect("was_polluted", get_node("/root/Root"), "on_polluted")
	self.connect("was_polluted", sound, "on_pollution")
	self.connect("rotated_left", sound, "on_rotate_right")
	self.connect("rotated_right", sound, "on_rotate_left")
