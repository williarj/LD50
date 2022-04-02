extends Path2D
class_name packetpath

export(Globals.Cardinal) var side1 = Globals.Cardinal.WEST
export(Globals.Cardinal) var side2 = Globals.Cardinal.NORTH

func get_next_path():
	var box  = get_parent().get_parent()
	var next_path = box.get_connected_path(side2)
	
	return next_path
