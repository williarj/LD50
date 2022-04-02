extends gridmember
class_name source

var resource = 0 # todo\

var amount : int = 500
var packetScene = preload("res://scenes/Packet.tscn")

export(Globals.Cardinal) var output_cardinal = Globals.Cardinal.NORTH setget set_output_cardinal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_game_tick():
	#print("received game tick")
	var newPacket : packet = packetScene.instance()
	(newPacket as packet).set_path($Paths/Path2D, +1)
	#$Area2D/box_sprite.modulate = Color(0, 0, 1)

func set_output_cardinal(new_value):
	output_cardinal = new_value
	self.direction = output_cardinal
