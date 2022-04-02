extends Node
class_name gameclock

signal game_tick

var tickspersec : int = 2
var secspertick : float = 1.0 / tickspersec
var timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "on_timer")
	timer.wait_time = self.secspertick
	add_child(timer)
	self.start()


func start():
	timer.start()

func toggle_pause():
	timer.paused = !timer.paused

func on_timer():
	# reset timer
	timer.start()
	emit_signal("game_tick")
	print("tick")
