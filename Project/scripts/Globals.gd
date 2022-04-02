class_name Globals
extends Reference

enum Cardinal {
	NORTH = 0,
	EAST  = 1,
	SOUTH = 2,
	WEST  = 3
}

static func opposite_direction(cardinal : int) -> int:
	assert(cardinal in Cardinal.values(), "wrong cardinal value")
	
	return (cardinal + 2) % 4
