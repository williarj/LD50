extends Node
class_name square

var connections : Array = [[]]

var neighbors : Array = []

var A2D : Area2D

var direction : int = 0 #0 = North, 1 = East, etc

# Called when the node enters the scene tree for the first time.
func _ready():
	self.A2D = ($Area2D as Area2D)

func _on_Area2D_rotate_left():
	var original : int = self.direction
	self.A2D.rotation_degrees = fmod(self.A2D.rotation_degrees - 90, 360)
	self.direction = (self.direction + 3) % 4
	print("%d -> %d" % [original, self.direction])


func _on_Area2D_rotate_right():
	var original : int = self.direction
	self.A2D.rotation_degrees = fmod(self.A2D.rotation_degrees + 90, 360)
	direction = (direction + 1) % 4
	print("%d -> %d" % [original, self.direction])

func get_shortest_path_from(cardinal : int, visited : Array = []) -> Array:
	assert(cardinal in Globals.Cardinal.values(), "source_dir must be a Cardinal direction")
	
	# transform cardinal direction (i.e "true north")
	# into what side of the box it is
	# so we can check connections
	var source_side : int = self.convert_cardinal_to_side(cardinal)
	
	var paths = []
	# check list of connections to see if the side is connected somewhere
	for connection in connections:
		# if the side is connected to something
		if connection.has(source_side):
			# check all destinations
			for destination in connection:
				# if it's a different side
				if destination != source_side:
					# here we have a possible path
					var check_cardinal : int = self.convert_side_to_cardinal(destination)
					if self.is_neighbor_a_sink(check_cardinal):
						# path is over!
						
						pass
					var neighbor : square = self.get_neighbor_by_cardinal(check_cardinal)
					# skip loops
					if visited.has(neighbor):
						continue
					var possible : Array = neighbor.get_shortest_path_from((check_cardinal + 2) % 4, visited + [self])
					
	return []

func convert_side_to_cardinal(side : int) -> int:
	assert(side in Globals.Cardinal.values(), "wrong side value")
	
	return (side + self.direction) % 4

func convert_cardinal_to_side(cardinal : int) -> int:
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	return (cardinal - self.direction + 4) % 4

func is_neighbor_a_sink(cardinal : int) -> bool:
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	return false

func get_neighbor_by_cardinal(cardinal : int):
	assert(cardinal in Globals.Cardinal.values(), "wrong cardinal value")
	
	if len(neighbors) == 4:
		return self.neighbors[cardinal]
	else:
		return null

func set_neighbors(neighbors : Array):
	assert(len(neighbors) == 4, "need neighbors for exactly four direction")
	self.neighbors = neighbors
