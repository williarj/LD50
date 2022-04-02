extends PathFollow2D
class_name packet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resource_type #should be Globals.Resources
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
		self.offset = self.offset + rate * path_direction * delta
		if (self.path_direction > 0 and self.unit_offset >= 0.90) or (self.path_direction < 0 and self.unit_offset <= 0.10) :
			path_complete = true
	else:
		position = position + direction * rate * delta
	
	if (path_complete):
		self.update_path()

func set_path(path : packetpath, direction : int):
	self.path = path
	self.path_complete = false
	self.path_direction = direction
	if direction > 0:
		self.unit_offset = 0
	else:
		self.unit_offset = 1

	if self.path != null:
		if self.get_parent() != null:
			self.get_parent().remove_child(self)
		self.path.add_child(self)


func update_path():
	if self.path != null:
		var next_path_info = path.get_next_path_info(self.unit_offset)
		if next_path_info == null:
			set_path(null, 1)
		else:
			var next_path = next_path_info[0]
			var direction = next_path_info[1]
			self.set_path(next_path, direction)
