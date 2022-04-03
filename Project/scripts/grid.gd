extends Node
class_name grid

signal source_spawned(spawned)
signal sink_spawned(spawned)
signal no_boxes_available()
signal all_sinks()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var grid_size = 5
var box_size = 50
var box_buffer = 0.05 #percentage of box size
var grid_border = 25
var box_matrix
var HHH : hectic

var boxScene = preload("res://scenes/Box.tscn")
var ssScene = preload("res://scenes/SourceSink.tscn")

var road_color_key = [Color("0026FF"),
					Color("267F00"),
					Color("FFD800"),
					Color("FF6A00"),
					Color("B200FF"),
					Color("FF0000")]

var road_scenes = [preload("res://scenes/tiles/road_tile_I.tscn"),
				preload("res://scenes/tiles/road_tile_L.tscn"),
				preload("res://scenes/tiles/road_tile_T.tscn"),
				preload("res://scenes/tiles/road_tile_X.tscn"),
				preload("res://scenes/tiles/road_tile_C.tscn"),
				preload("res://scenes/tiles/road_tile_O.tscn")
				]
				
var rand_road_weights = [10,
					5,
					3,
					2,
					2,
					2]
var weight_sum = 0

var rng = RandomNumberGenerator.new()
var sound_manager
var settings_singleton : settings_singleton

# Called when the node enters the scene tree for the first time.
func _ready():
	settings_singleton = get_node("/root/SettingsSingleton")
	rng.randomize()
	
	HHH = hectic.new()
	sound_manager = $sound_manager as sound_manager
	
	for w in rand_road_weights:
		weight_sum += w
	set_up_grid(settings_singleton.level_to_load)
	
func set_up_grid(file = null):
	if file == null:
		self.box_matrix = generate_random_grid()
	else:
		self.box_matrix = generate_csv_grid(file)
	
	####Set each box's neighbors
	#"ss cells dont need checked"
	for i in range(1,grid_size+1):
		for j in range(1,grid_size+1):
			var box_script : gridmember = box_matrix[i][j]
			box_script.set_neighbors([ box_matrix[i][j-1],
									box_matrix[i+1][j],
									box_matrix[i][j+1],
									box_matrix[i-1][j] ])
	
	var source_script : gridmember
	for j in range(1, grid_size+1):
		source_script = box_matrix[0][j]
		source_script.set_neighbors([null, box_matrix[1][j], null, null])
		
		source_script = box_matrix[grid_size+1][j]
		source_script.set_neighbors([null, null, null, box_matrix[grid_size][j]])
		
	for i in range(1, grid_size+1):
		source_script = box_matrix[i][0]
		source_script.set_neighbors([null, null, box_matrix[i][1], null])
		
		source_script = box_matrix[i][grid_size+1]
		source_script.set_neighbors([box_matrix[i][grid_size], null, null, null])
	
	#clock.connect("game_tick", box_matrix[0][1], "on_game_tick")
	
	#activate_sink(grid_size+1, 1, Globals.Resources.CIRCLE)
	
		
	#var bg_sprite = get_node("grid_bg")
	#var last_node_pos : Vector2 = box_array[-1][-1].get_position()
	#bg_sprite.scale = Vector2(last_node_pos.x/500, last_node_pos.y/300)
			

func generate_empty_grid():
	var box_matrix = []
	for i in range(grid_size+2):#+2 gives the border of source/sink cells
		var box_row = []
		for j in range(grid_size+2):
			var new_box : gridmember
			if (i == 0 or j == 0 or i > grid_size or j > grid_size):
				new_box = ssScene.instance()
				new_box.HHH = self.HHH
				if i == 0:
					new_box.direction = Globals.Cardinal.EAST
				elif j == 0:
					new_box.direction = Globals.Cardinal.SOUTH
				elif i == grid_size+1:
					new_box.direction = Globals.Cardinal.WEST
				elif j == grid_size+1:
					new_box.direction = Globals.Cardinal.NORTH
				add_child(new_box)
				new_box.parent_grid = self
				new_box.set_position(Vector2(grid_border+i*box_size*(1+box_buffer), 
											grid_border+j*box_size*(1+box_buffer)))
				new_box.connect_to_sound(sound_manager)
			else:
				new_box = null
			box_row.append(new_box)
		box_matrix.append(box_row)
	return box_matrix

func generate_random_grid():
	####Generate all the boxes in the grid
	var box_matrix = generate_empty_grid()
	for i in range(1,grid_size+1):#skips the border cells, they were done already
		var box_row = []
		for j in range(1,grid_size+1):
			var new_box : gridmember
			new_box = pick_random_road().instance()
			box_matrix[i][j] = new_box
			add_child(new_box)
			new_box.parent_grid = self
			new_box.set_position(Vector2(grid_border+i*box_size*(1+box_buffer), 
										grid_border+j*box_size*(1+box_buffer)))
			new_box.connect_to_sound(sound_manager)
	return box_matrix

func generate_csv_grid(csv_file):
	var open_file = File.new()
	open_file.open(csv_file, File.READ)
	
	var new_box_matrix = generate_empty_grid()
	var i = 1
	while !open_file.eof_reached():
		var line = open_file.get_line()
		#assert(i <= grid_size, "CSV with incompatible grid size loaded")
		if i > grid_size:
			continue
		var sline = line.split(",")
		var j = 1
		for col in sline:
			#assert(j <= grid_size, "CSV with incompatible grid size loaded")
			if j > grid_size:
				continue
			var new_box = spawn_road_by_index(int(col)).instance()
			new_box_matrix[j][i] = new_box #these indices are backwards, because of reasons
			add_child(new_box)
			new_box.parent_grid = self
			new_box.set_position(Vector2(grid_border+j*box_size*(1+box_buffer), 
										grid_border+i*box_size*(1+box_buffer)))
			new_box.connect_to_sound(sound_manager)
			j += 1
		i += 1
	open_file.close()
	return new_box_matrix
	

func activate_source(box, resource_type, amount = 10):
	assert(resource_type in Globals.Resources.values(), "need valid resource type")
	box.set_as_source( resource_type, amount)

func activate_sink(box, resource_type, amount = 10):
	assert(resource_type in Globals.Resources.values(), "need valid resource type")
	box.set_as_sink(true, resource_type, amount)

func pick_random_road():
	var index = self.sample_with_weights(rand_road_weights, weight_sum)
	return road_scenes[index]

func spawn_road_by_index(index):
	return road_scenes[index]

func spawn_random_source(res):
	var random_border = choose_random_empty_border()
	if (random_border == null):
		return false
	activate_source(random_border, res, 20)
	#todo change resources
	emit_signal("source_spawned", random_border)
	return true

func spawn_random():
	var res = choose_random_resource()
	var spawned = spawn_random_sink(res)
	spawn_random_source(res)
	return spawned

func spawn_random_sink(res):
	var random_border = choose_random_empty_border()
	if (random_border == null):
		return false
	activate_sink(random_border, res)
	#todo change resources
	emit_signal("sink_spawned", random_border)
	return true

func choose_random_resource():
	return Globals.Resources.values()[rng.randi_range(0, len(Globals.Resources.values())-1)]

func choose_random_empty_border():
	var empty_boxes = []
	var source_script
	var found_source = false
	#checks left and right
	for j in range(1, grid_size+1):
		source_script = box_matrix[0][j] as source
		if !(source_script.is_source or source_script.is_sink):
			empty_boxes.append(source_script)
		if (source_script.is_source):
			found_source = true
		source_script = box_matrix[grid_size+1][j]
		if !(source_script.is_source or source_script.is_sink):
			empty_boxes.append(source_script)
		if (source_script.is_source):
			found_source = true
		
	
	#checks top and bottom
	for i in range(1, grid_size+1):
		source_script = box_matrix[i][0]
		if !(source_script.is_source or source_script.is_sink):
			empty_boxes.append(source_script)
		if (source_script.is_source):
			found_source = true
		source_script = box_matrix[i][grid_size+1]
		if !(source_script.is_source or source_script.is_sink):
			empty_boxes.append(source_script)
		if (source_script.is_source):
			found_source = true
			
	#sample one from the list of boxes
	if len(empty_boxes) == 0:
		print("NO FREE BOXES")
		emit_signal("no_boxes_available")
		if (!found_source):
			emit_signal("all_sinks")
		return null
	return empty_boxes[rng.randi_range(0, len(empty_boxes)-1)]

func sample_with_weights(arr, sum):
	var p = rng.randf()
	var cum_p = 0
	for i in range(len(arr)-1):
		var v = arr[i]
		cum_p += v/float(sum)
		if p < cum_p:
			return i
	return len(arr)-1
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func randomly_rotate(n_boxes):
	var boxes = range(0, grid_size*grid_size)
	boxes.shuffle()
	boxes = boxes.slice(0, n_boxes-1)
	for k in boxes:
		var i = int(float(k) / grid_size)
		var j = k % grid_size
		var n_rots = 1 + (randi() % 3)
		if randf() < 0.5:
			box_matrix[1+i][1+j].rotate_left(n_rots)
		else:
			box_matrix[1+i][1+j].rotate_right(n_rots)

