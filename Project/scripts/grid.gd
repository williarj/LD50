extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var grid_size = 5
var box_size = 50
var box_buffer = 0.05 #percentage of box size
var grid_border = 25
var boxScene = preload("res://scenes/Box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	####Generate all the boxes in the grid
	#add a border of "source cells"
	var box_matrix = []
	for i in range(grid_size):
		var box_row = []
		for j in range(grid_size):
			var new_box = boxScene.instance()
			add_child(new_box)
			new_box.set_position(Vector2(grid_border+i*box_size*(1+box_buffer), 
										grid_border+j*box_size*(1+box_buffer)))
			box_row.append(new_box)
		box_matrix.append(box_row)
		
	####Set each box's neighbors
	#"source cells dont need checked"
	for i in range(grid_size):
		for j in range(grid_size):
			#var box_script : square = box_matrix[i][j].root
			var neighbors = []
			#north
			#fuck this
				
		
	#var bg_sprite = get_node("grid_bg")
	#var last_node_pos : Vector2 = box_array[-1][-1].get_position()
	#bg_sprite.scale = Vector2(last_node_pos.x/500, last_node_pos.y/300)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
