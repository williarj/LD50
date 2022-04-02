extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = 0 #0 = North, 1 = East, etc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area2D_rotate_left():
	$Area2D.rotation_degrees = fmod($Area2D.rotation_degrees - 90, 360)
	direction = (direction + 3) % 4
	print(direction)


func _on_Area2D_rotate_right():
	$Area2D.rotation_degrees = fmod($Area2D.rotation_degrees + 90, 360)
	direction = (direction + 1) % 4
	print(direction)
