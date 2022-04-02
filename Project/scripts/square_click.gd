extends Area2D

signal rotate_right
signal rotate_left

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		match (event.button_index):
			BUTTON_LEFT: self.left_rotate()
			BUTTON_RIGHT: self.right_rotate()
			

func right_rotate():
	print("ROTATE RIGHT")
	emit_signal("rotate_right")
	
func left_rotate():
	print("ROTATE LEFT")
	emit_signal("rotate_left")
