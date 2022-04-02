extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if node.get_class() == "Path2D":
			self.add_flipped_path(node as Path2D)

func add_flipped_path(path : Path2D):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
