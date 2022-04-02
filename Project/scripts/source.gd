extends gridmember
class_name source

var resource = 0 # todo\

var amount : int = 500
var packetScene = preload("res://scenes/Packet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.paths = [$Paths/Path2D]

func on_game_tick():
	#print("received game tick")
	var newPacket : packet = packetScene.instance()
	(newPacket as packet).set_path($Paths/Path2D, +1)
	#$Area2D/box_sprite.modulate = Color(0, 0, 1)
