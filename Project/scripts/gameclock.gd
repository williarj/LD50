extends Node
class_name gameclock

signal game_tick

var HHH : hectic = hectic.new()
var seconds_per_hectic
var hectic_delay = 20
var secs_per_hectic = 10
var hectic_timer = Timer.new()
var panic_timer = Timer.new()

var source_timer : Timer = Timer.new()
var sink_timer : Timer = Timer.new()

var score : int = 0 setget set_score

var gamegrid : grid

var source_lag_times = [1,1,2,2,5]
var source_lag_after = 5
var sink_lag_times = [1,1,2,2,2,2]
var sink_lag_after = 7
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	source_timer.connect("timeout", self, "on_source_timer")
	source_timer.one_shot = true
	add_child(source_timer)
	
	sink_timer.connect("timeout", self, "on_sink_timer")
	sink_timer.one_shot = true
	add_child(sink_timer)
	
	hectic_timer.connect("timeout", self, "on_hectic_timeout")
	add_child(hectic_timer)
	
	panic_timer.connect("timeout", self, "on_panic_timeout")
	panic_timer.one_shot = true
	add_child(panic_timer)
	
	#timer.one_shot = true
	self.gamegrid = $grid
	self.gamegrid.spawn_random_source()
	self.gamegrid.spawn_random_sink()
	self.gamegrid.HHH = self.HHH
	
	start_source_timer()
	start_sink_timer()
	start_hectic_timer()

func start_source_timer():
	var wait_time 
	if (len(source_lag_times) > 0):
		wait_time = source_lag_times.pop_front()
	else:
		wait_time = max(5.0, rng.randfn(source_lag_after, source_lag_after*0.2))
	source_timer.wait_time = wait_time
	source_timer.start()
	

func start_sink_timer():
	var wait_time 
	if (len(sink_lag_times) > 0):
		wait_time = sink_lag_times.pop_front()
	else:
		wait_time = max(5.0, rng.randfn(sink_lag_after, sink_lag_after*0.2))
	sink_timer.wait_time = wait_time
	sink_timer.start()

func start_hectic_timer():
	hectic_timer.wait_time = self.hectic_delay
	hectic_timer.start()

func on_source_timer():
	#print("NEW SOURCE!")
	self.gamegrid.spawn_random_source()
	self.start_source_timer()
	
func on_sink_timer():
	#print("NEW SINK!")
	self.gamegrid.spawn_random_sink()
	self.start_sink_timer()


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

func on_hectic_timer():
	HHH.hectic_level += 1
	var level = HHH.hectic_level
	if rng.randf() < multiply_prob(0.075, level):
		self.gamegrid.randomly_rotate(rng.randi_range(level, level*2))
	if rng.randf() < multiply_prob(0.075, level):
		self.panic_mode(rng.randi_range(level, level*2))
	if rng.randf() < multiply_prob(0.2, level):
		self.HHH.perm_speed_mult *= (1.0 + rng.randf_range(0.05, 0.15))

func panic_mode(seconds):
	if panic_timer.is_stopped():
		panic_timer.wait_time = seconds
		self.HHH.panic_speed_mult = 2.0
		panic_timer.start()

func on_panic_timeout():
	self.HHH.panic_speed_mult = 1.0

func multiply_prob(p, n):
	return 1.0 - pow(1.0 - p, n)
