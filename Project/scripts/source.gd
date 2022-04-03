extends gridmember
class_name source

signal resource_delivered(destination, type_delivered)
signal resource_misdelivered(destination, type_delivered, type_wanted)
signal source_depleted(s)
signal sink_satisfied(s)
signal amount_changed(a)
signal resource_spawned(type)
signal became_source(type)
signal became_sink(type)

export var resource = Globals.Resources.CIRCLE setget set_resource

var amount : int = 500 setget set_amount
var spawn_rate : float = 1.0
var HHH : hectic

var is_source : bool = false
var is_sink : bool = false setget set_is_sink
var packetScene = preload("res://scenes/Packet.tscn")
var source_color = Color.darkseagreen
var sink_color = Color.bisque


var resource_to_sprite_map = {
	Globals.Resources.CIRCLE : load("res://assets/art/source2.png"),
	Globals.Resources.SQUARE : load("res://assets/art/source1.png"),
	Globals.Resources.TRIANGE : load("res://assets/art/source3.png")
}

func set_resource(new_val):
	resource = new_val
	$resource_sprite.texture = resource_to_sprite_map[resource]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.paths = $Paths.get_children()
	$SpawnTimer.wait_time = 1.0 / spawn_rate
	$SpawnTimer.add_to_group("pauseable_timers", true)
	#$Label_node/Label.text = str(amount)

func set_amount(new_val : int):
	amount = new_val
	emit_signal("amount_changed", amount)
	$LabelNode/Label.text = str(amount)
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
	$SpawnTimer.wait_time = 1.0 / (spawn_rate / 3)
	$SpawnTimer.one_shot = true
	$SpawnTimer.start()
	self.visible = true
	$Area2D/box_sprite.modulate = source_color
	emit_signal("became_source", self.resource)
	
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
		$Area2D/box_sprite.modulate = sink_color
		emit_signal("became_sink", self.resource)
	else:
		self.visible = true
		$Area2D/box_sprite.modulate = Color(0, 0, 0, 1)
		
		
func set_is_sink(new_val):
	if (new_val != is_sink):
		$Area2D/box_sprite.rotation_degrees += fmod(180, 360)
	is_sink = new_val
	

func _on_SpawnTimer_timeout():
	#print("received game tick")
	if ($SpawnTimer.one_shot):
		#make sure we reset the timer length after the first spawn
		$SpawnTimer.wait_time = 1.0 / spawn_rate 
		$SpawnTimer.one_shot = false
		$SpawnTimer.start()
	
	if (is_source and self.amount > 0):
		self.set_amount(self.amount-1)
		var newPacket = packetScene.instance()
		newPacket.set_path($Paths/Path2D)
		newPacket.resource_type = self.resource
		newPacket.set_resource_sprite(resource_to_sprite_map[self.resource])
		newPacket.rate *= self.HHH.total_speed_mult()
		emit_signal("resource_spawned", self.resource)
		#$Area2D/box_sprite.modulate = Color(0, 0, 1)

func set_direction(new_direction):
	direction = new_direction
	self.rotation_degrees = fmod(new_direction * 90, 360)
	$LabelNode.rotation_degrees = fmod(-1*new_direction * 90, 360)

func connect_to_sound(sound):
	self.connect("resource_delivered", sound, "on_correct_delivery")
	self.connect("resource_misdelivered", sound, "on_bad_delivery")
	self.connect("source_depleted", sound, "on_source_depleted")
	self.connect("sink_satisfied", sound, "on_sink_satisfied")
	self.connect("resource_spawned", sound, "on_resource_spawn")
	self.connect("became_source", sound, "on_become_source")
	self.connect("became_sink", sound, "on_become_sink")
