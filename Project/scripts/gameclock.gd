extends Node
class_name gameclock

signal game_tick

var HHH : hectic = hectic.new()
var seconds_per_hectic
var hectic_delay = 10
var secs_per_hectic = 5
var hectic_timer = Timer.new()
var panic_timer = Timer.new()

var spawn_timer : Timer = Timer.new()
var sink_timer : Timer = Timer.new()

var score : int = 0 setget set_score

var gamegrid : grid

var pausetime : float = 15.0 setget set_pausetime
var userpaused : bool = false setget set_userpaused

var initial_spawn_lags = [4,3]
var spawn_lag = 2
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	#global randomize
	randomize()
	
	spawn_timer.connect("timeout", self, "on_spawn_timer")
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	
	hectic_timer.connect("timeout", self, "on_hectic_timeout")
	add_child(hectic_timer)
	
	panic_timer.connect("timeout", self, "on_panic_timeout")
	panic_timer.one_shot = true
	add_child(panic_timer)
	
	#timer groups
	spawn_timer.add_to_group("pauseable_timers",true)
	hectic_timer.add_to_group("pauseable_timers",true)
	panic_timer.add_to_group("pauseable_timers",true)
	
	#timer.one_shot = true
	self.gamegrid = $grid
	self.gamegrid.spawn_random()
	self.HHH = self.gamegrid.HHH
	
	start_spawn_timer()
	start_hectic_timer()
	
	#center window for sanity
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) and pausetime > 0.0:
		self.userpaused = true
		self.pausetime -= delta
	else:
		self.userpaused = false

func start_spawn_timer():
	var wait_time 
	if (len(initial_spawn_lags) > 0):
		wait_time = initial_spawn_lags.pop_front()
	else:
		wait_time = spawn_lag
	spawn_timer.wait_time = wait_time
	spawn_timer.start()

func start_hectic_timer():
	hectic_timer.wait_time = self.hectic_delay
	hectic_timer.start()

func on_spawn_timer():
	#print("NEW SOURCE!")
	self.gamegrid.spawn_random()
	self.start_spawn_timer()

func _on_grid_sink_spawned(spawned):
	spawned.connect("resource_delivered", self, "on_sink_resource_delivered")
	spawned.connect("resource_misdelivered", self, "on_sink_resource_misdelivered")
	spawned.connect("sink_satisfied", self, "on_sink_satisfied")

func _on_grid_source_spawned(spawned):
	spawned.connect("source_depleted", self, "on_source_depleted")

func on_sink_resource_delivered(sink, type_delivered):
	self.pausetime += 0.05
	#increase points
	self.score += 1
	pass

func on_sink_resource_misdelivered(sink, type_delivered, type_wanted):
	#decrease points
	self.score -= 1
	pass

func on_sink_satisfied(sink):
	self.pausetime += 1
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

func on_hectic_timeout():
	HHH.hectic_level += 1
	var level = HHH.hectic_level
	if rng.randf() < multiply_prob(0.2, level):
		self.gamegrid.randomly_rotate(rng.randi_range(level, level*2))
	if rng.randf() < multiply_prob(0.1, level):
		self.panic_mode(rng.randi_range(level, level*2))
	if rng.randf() < multiply_prob(0.2, level):
		self.HHH.perm_speed_mult *= (1.0 + rng.randf_range(0.05, 0.15))
	if rng.randf() < multiply_prob(1.0/3.0, level):
		get_tree().call_group("tiles", "increase_pollution_mult", 0.25)

func panic_mode(seconds):
	if panic_timer.is_stopped():
		panic_timer.wait_time = seconds
		self.HHH.panic_speed_mult = 2.0
		panic_timer.start()

func on_panic_timeout():
	self.HHH.panic_speed_mult = 1.0

func multiply_prob(p, n):
	return 1.0 - pow(1.0 - p, n)

func set_pausetime(new_value):
	pausetime = clamp(new_value, 0.0, 90.0)
	var val_label : Label = $pause_time/value
	val_label.text = "%0.2f" % pausetime

func set_userpaused(new_value):
	self.HHH.is_paused = new_value
	if userpaused != new_value:
		get_tree().set_group("pauseable_timers", "paused", new_value)
		get_tree().set_group("packets", "paused", new_value)
	userpaused = new_value


func _on_settings_node_close():
	get_tree().change_scene("res://scenes/splash.tscn")
	pass # Replace with function body.
