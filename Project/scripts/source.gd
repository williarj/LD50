extends gridmember
class_name source

signal resource_delivered(destination, type_delivered)
signal resource_misdelivered(destination, type_delivered, type_wanted)
signal source_depleted(s)
signal sink_satisfied(s)

export var resource = Globals.Resources.CIRCLE 

var amount : int = 500 setget set_amount
var spawn_rate : float = 3.0

var is_source : bool = false
var is_sink : bool = false
var packetScene = preload("res://scenes/Packet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.paths = $Paths.get_children()
	$SpawnTimer.wait_time = 1.0 / spawn_rate
	$Label.text = str(amount)

func set_amount(new_val : int):
	amount = new_val
	$Label.text = str(amount)
	if(new_val <= 0):
		print("Resource exhausted/satisfied")
		if self.is_source:
			self.clean_up_source()
		elif self.is_sink:
			self.clean_up_sink()

func receive_packet(p):
	if self.is_sink:
		if p.resource_type != self.resource:
			emit_signal("resource_misdelivered", self, self.resource, p.resource_type)
		else:
			self.set_amount(self.amount-1)
			emit_signal("resource_delivered", self, p.resource_type)
			p.queue_free() #delete the resource

func set_as_source(resource, amount = 10):
	self.resource = resource
	self.is_source = true
	self.is_sink = false
	self.set_amount(amount)
	#clock.connect("game_tick", self, "on_game_tick")
	$SpawnTimer.start()
	self.visible = true
	$Area2D/box_sprite.modulate = Color(0, 0, 1, 1)
	
func clean_up_source():
	self.is_source = false
	#clock.disconnect("game_tick", self, "on_game_tick")
	$SpawnTimer.stop()
	self.visible = false
	emit_signal("source_depleted", self)

func clean_up_sink():
	self.visible = false
	self.is_sink = false
	emit_signal("sink_satisfied", self)
	
func set_as_sink(is_sink : bool, resource, amount = 10):
	self.resource = resource
	self.is_sink = is_sink
	self.set_amount(amount)
	if (self.is_sink):
		self.is_source = false
		self.visible = true
		$Area2D/box_sprite.modulate = Color(1, 0, 0, 1)
	else:
		self.visible = true
		$Area2D/box_sprite.modulate = Color(0, 0, 0, 1)
		

func _on_SpawnTimer_timeout():
	#print("received game tick")
	if (is_source and self.amount > 0):
		self.set_amount(self.amount-1)
		var newPacket = packetScene.instance()
		newPacket.set_path($Paths/Path2D)
		newPacket.resource_type = self.resource
		#$Area2D/box_sprite.modulate = Color(0, 0, 1)
