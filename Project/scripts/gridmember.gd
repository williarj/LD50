extends Node2D
class_name gridmember

var neighbors : Array = []
var parent_grid 

var paths = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

var direction : int = 0 setget set_direction

func get_neighbor_by_cardinal(cardinal : int):
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	if len(neighbors) == 4:
		return self.neighbors[cardinal]
	else:
		return null

func set_neighbors(neighbors : Array):
	assert(len(neighbors) == 4, "need neighbors for exactly four direction")
	self.neighbors = neighbors

func set_direction(new_direction):
	direction = new_direction
	self.rotation_degrees = fmod(new_direction * 90, 360)

func convert_side_to_cardinal(side : int) -> int:
	assert(side in Globals.Cardinal.values(), "wrong side value")
	
	return (side + self.direction) % 4

func convert_cardinal_to_side(cardinal : int) -> int:
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	return (cardinal - self.direction + 4) % 4
	
func get_neighbor_by_side(side : int):
	assert(side in Globals.Cardinal.values(), "wrong side value")
	
	var cardinal = self.convert_side_to_cardinal(side)
	
	return self.get_neighbor_by_cardinal(cardinal)
	
func get_connected_path(side : int):
	var from_direction = Globals.opposite_direction(self.convert_side_to_cardinal(side))
	var neighbor = self.get_neighbor_by_side(side)
	
	return neighbor.get_path_from_cardinal(from_direction)
	
func get_path_from_cardinal(cardinal):
	var side = self.convert_cardinal_to_side(cardinal)
	var possible_paths = []
	for path in paths:
		if side == path.side1:
			possible_paths.append(path)
	if len(possible_paths) == 0:
		return null
	else:
		return possible_paths[rng.randi_range(0, len(possible_paths)-1)]
		
func receive_packet(p : packet):
	pass
