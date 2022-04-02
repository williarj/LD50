extends gridmember
class_name source

export var resource = Globals.Resources.CIRCLE 

var amount : int = 500 setget set_amount
var is_source : bool = false
var is_sink : bool = false
var packetScene = preload("res://scenes/Packet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.paths = [$Paths/Path2D]
	$Label.text = str(amount)

func set_amount(new_val : int):
	amount = new_val
	$Label.text = str(amount)
	if(new_val <= 0):
		print("Resource exhausted/satisfied")

func on_game_tick():
	#print("received game tick")
	if (is_source and self.amount > 0):
		self.set_amount(self.amount-1)
		var newPacket : packet = packetScene.instance()
		(newPacket as packet).set_path($Paths/Path2D)
		#$Area2D/box_sprite.modulate = Color(0, 0, 1)

func recieve_packet(p : packet):
	if(!is_sink or p.resource_type != self.resource):
		#todo: error
		pass
	else:
		self.set_amount(self.amount-1)
		p.queue_free() #delete the resource

func set_as_source(clock, resource, amount = 10):
	self.resource = resource
	self.is_source = true
	self.is_sink = false
	self.set_amount(self.amount)
	clock.connect("game_tick", self, "on_game_tick")
	$Area2D/box_sprite.modulate = Color(0, 0, 1)
	
func clean_up_source(clock):
	self.resource = resource
	self.is_source = false
	clock.disconnect("game_tick", self, "on_game_tick")
	$Area2D/box_sprite.modulate = Color(0, 0, 0)
	
func set_as_sink(is_sink : bool, resource, amount = 10):
	self.resource = resource
	self.is_sink = is_sink
	self.set_amount(self.amount)
	if (self.is_sink):
		self.is_source = false
		$Area2D/box_sprite.modulate = Color(1, 0, 0)
	else:
		$Area2D/box_sprite.modulate = Color(0, 0, 0)
		
