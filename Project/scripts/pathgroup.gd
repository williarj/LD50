extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if node.get_class() == "Path2D":
			self.add_flipped_path(node as packetpath)

func add_flipped_path(path : packetpath):
	var flipped = packetpath.new()
	for i in range(path.curve.get_point_count()-1, -1, -1):
		flipped.curve.add_point(path.curve.get_point_position(i),
								path.curve.get_point_in(i),
								path.curve.get_point_out(i))
	flipped.name = path.name + "_flipped"
	flipped.side1 = path.side2
	flipped.side2 = path.side1
	flipped.position = path.position
	add_child(flipped)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
