extends Node
class_name gameclock

signal game_tick

var tickspersec : int = 2
var secspertick : float = 1.0 / tickspersec
var source_timer : Timer = Timer.new()
var sink_timer : Timer = Timer.new()

var score : int = 0 setget set_score

var gamegrid : grid

var source_lag_times = [5,10,20]
var sink_lag_times = [1,2,1,1,1,1,1,2]
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	source_timer.connect("timeout", self, "on_source_timer")
	add_child(source_timer)
	sink_timer.connect("timeout", self, "on_sink_timer")
	add_child(sink_timer)
	#timer.one_shot = true
	self.gamegrid = $grid
	self.gamegrid.spawn_random_source()
	self.gamegrid.spawn_random_sink()
	
	start_source_timer()
	start_sink_timer()

func start_source_timer():
	var wait_time 
	if (len(source_lag_times) > 0):
		wait_time = source_lag_times.pop_front()
	else:
		wait_time = rng.randfn(20, 5)
	source_timer.wait_time = wait_time
	source_timer.start()
	

func start_sink_timer():
	var wait_time 
	if (len(sink_lag_times) > 0):
		wait_time = sink_lag_times.pop_front()
	else:
		wait_time = rng.randfn(20, 5)
	sink_timer.wait_time = wait_time
	sink_timer.start()

func on_source_timer():
	#print("NEW SOURCE!")
	self.gamegrid.spawn_random_source()
	
func on_sink_timer():
	#print("NEW SINK!")
	self.gamegrid.spawn_random_sink()

func _on_grid_sink_spawned(spawned):
	spawned.connect("resource_delivered", self, "on_sink_resource_delivered")
	spawned.connect("resource_misdelivered", self, "on_sink_resource_misdelivered")
	spawned.connect("sink_satisfied", self, "on_sink_satisfied")

func _on_grid_source_spawned(spawned):
	spawned.connect("source_depleted", self, "on_source_depleted")

func on_sink_resource_delivered(sink, type_delivered):
	#increase points
	self.score += 1
	pass

func on_sink_resource_misdelivered(sink, type_delivered, type_wanted):
	#decrease points
	self.score -= 1
	pass

func on_sink_satisfied(sink):
	#extra points?
	self.score += 10
	sink.disconnect("resource_delivered", self, "on_sink_resource_delivered")
	sink.disconnect("resource_misdelivered", self, "on_sink_resource_misdelivered")
	sink.disconnect("sink_satisfied", self, "on_sink_satisfied")

func on_source_depleted(s):
	s.disconnect("source_depleted", self, "on_source_depleted")

func set_score(new_val):
	score = new_val
	$score_num.text = str(score)
