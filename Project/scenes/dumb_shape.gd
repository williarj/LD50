extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var delay = 0
export var speed = 20
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (delay > 0):
		delay -= delta
	else:
		$PathFollow2D.offset += delta*speed
	pass
