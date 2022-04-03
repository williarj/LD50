extends Node2D
class_name gridmember

var neighbors : Array = []
var n_neighbors = 0
var parent_grid 

var paths = []
var rng = RandomNumberGenerator.new()

var tween : Tween = Tween.new()

func _ready():
	add_child(tween)
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
	self.n_neighbors = 0
	for neighbor in neighbors:
		if neighbor != null:
			n_neighbors += 1

func get_class():
	return "gridmember"

#instant change in direction
func set_direction(new_direction):
	direction = new_direction % 4
	self.rotation_degrees = fmod(new_direction * 90, 360)

func rotate_right(n=1):
	var old_direction = direction
	var new_direction = (old_direction + n) % 4
	direction = (new_direction + 4) % 4 #force positive
	
	tween.interpolate_property(self, "rotation_degrees", old_direction * 90, new_direction * 90, 0.1)
	tween.start()

func rotate_left(n=1):
	rotate_right(-n)

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
		
func packet_stopped(p : packet):
	pass

func packet_entered(p : packet):
	pass

func packet_exited(p : packet):
	pass
