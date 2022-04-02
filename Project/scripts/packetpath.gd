extends Path2D
class_name packetpath

export(Globals.Cardinal) var side1 = Globals.Cardinal.WEST
export(Globals.Cardinal) var side2 = Globals.Cardinal.NORTH

func get_next_path_info(unit_offset):
	var box  = get_parent().get_parent()
	var next_path_info
	
	if unit_offset > 0.5:
		next_path_info = box.get_connected_path(side2)
	else:
		next_path_info = box.get_connected_path(side1)
	
	return next_path_info
