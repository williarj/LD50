extends PathFollow2D
class_name packet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resource_type#should be Globals.Resources
var direction = Vector2.RIGHT
var rate : float = 60.0
var path : packetpath = null

var path_complete = true

var paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_resource_sprite(new_sprite):
	$Area2D/packet_sprite.texture = new_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(paused):
		return
	if (path != null):
		self.offset = self.offset + rate * delta
		if self.unit_offset >= 1.0 :
			path_complete = true
	else:
		position = position + direction * rate * delta
	
	if (path_complete):
		self.on_path_complete()

func set_path(path : packetpath):
	self.path = path
	self.path_complete = false
	self.unit_offset = 0

	if self.path != null:
		if self.get_parent() != null:
			self.get_parent().remove_child(self)
		self.path.add_child(self)
	else:
		self.queue_free()
		#todo: increment pollution
		pass


func on_path_complete():
	if self.path != null:
		var next_box = path.get_next_box()
		var next_path = null
		#if we reach the middle of a sink
		if (next_box == null):
			path.get_box().receive_packet(self)
		else:
			next_path = path.get_next_path()
			#check if we dead-ended into a non-sink box
			if (next_path == null):
				next_box.receive_packet(self)
		self.set_path(next_path)
