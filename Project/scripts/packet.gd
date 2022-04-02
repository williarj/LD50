extends PathFollow2D
class_name packet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2.RIGHT
var rate : float = 20.0
var path : packetpath = null

var path_complete = true

var path_direction = +1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (path != null):
		self.offset = self.offset + rate * delta
		if self.unit_offset >= 1.0 :
			path_complete = true
	else:
		position = position + direction * rate * delta
	
	if (path_complete):
		self.update_path()

func set_path(path : packetpath):
	self.path = path
	self.path_complete = false
	self.unit_offset = 0

	if self.path != null:
		if self.get_parent() != null:
			self.get_parent().remove_child(self)
		self.path.add_child(self)


func update_path():
	if self.path != null:
		self.set_path(path.get_next_path())
