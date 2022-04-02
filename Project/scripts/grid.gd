extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var grid_size = 5
var box_size = 50
var box_buffer = 0.05 #percentage of box size
var grid_border = 25
var boxScene = preload("res://scenes/Box.tscn")
var ssScene = preload("res://scenes/SourceSink.tscn")

var clock : gameclock

# Called when the node enters the scene tree for the first time.
func _ready():
	clock = (self.get_parent() as gameclock)
	
	####Generate all the boxes in the grid
	var box_matrix = []
	for i in range(grid_size+2):#+2 gives the border of source/sink cells
		var box_row = []
		for j in range(grid_size+2):
			var new_box
			if (i == 0 or j == 0 or i > grid_size or j > grid_size):
				new_box = ssScene.instance()
			else:
				new_box = boxScene.instance()
			add_child(new_box)
			new_box.set_position(Vector2(grid_border+i*box_size*(1+box_buffer), 
										grid_border+j*box_size*(1+box_buffer)))
			box_row.append(new_box)
		box_matrix.append(box_row)
		
	####Set each box's neighbors
	#"ss cells dont need checked"
	for i in range(1,grid_size):
		for j in range(1,grid_size):
			var box_script : gridmember = box_matrix[i][j]
			box_script.set_neighbors([ box_matrix[i][j-1],
									box_matrix[i+1][j],
									box_matrix[i][j+1],
									box_matrix[i-1][j] ])
	
	var source_script : gridmember
	for j in [1, grid_size]:
		source_script = box_matrix[0][j]
		source_script.set_neighbors([null, null, box_matrix[0][j+1], null])
	for j in [1, grid_size]:
		source_script = box_matrix[grid_size+1][j]
		source_script.set_neighbors([box_matrix[grid_size+1][j-1], null, null, null])
	for i in [1, grid_size]:
		source_script = box_matrix[i][0]
		source_script.set_neighbors([null, box_matrix[i+1][0], null, null])
	for i in [1, grid_size]:
		source_script = box_matrix[i][grid_size+1]
		source_script.set_neighbors([null, null, null, box_matrix[i-1][grid_size+1]])
	
	clock.connect("game_tick", box_matrix[0][1], "on_game_tick")
		
		
	#var bg_sprite = get_node("grid_bg")
	#var last_node_pos : Vector2 = box_array[-1][-1].get_position()
	#bg_sprite.scale = Vector2(last_node_pos.x/500, last_node_pos.y/300)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
