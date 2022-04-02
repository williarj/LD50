extends Node
class_name gridmember

var neighbors : Array = []

func get_neighbor_by_cardinal(cardinal : int):
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	if len(neighbors) == 4:
		return self.neighbors[cardinal]
	else:
		return null

func set_neighbors(neighbors : Array):
	assert(len(neighbors) == 4, "need neighbors for exactly four direction")
	self.neighbors = neighbors
