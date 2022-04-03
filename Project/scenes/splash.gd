extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var settings_singleton : settings_singleton
# Called when the node enters the scene tree for the first time.
func _ready():
	$settings_node/close_button.visible = false
	$settings_node/mute_sfx_button.visible = false
	settings_singleton = get_node("/root/SettingsSingleton")
	#center window for sanity
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_credits_button_button_up():
	$credits_panel.visible = true
	pass # Replace with function body.


func _on_random_map_button_button_up():
	settings_singleton.level_to_load = null
	get_tree().change_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.

var set_map = [[2,0,1,0,2],
[0,0,0,4,0],
[1,1,3,1,1],
[0,4,0,0,0],
[2,0,1,0,2]]


func _on_set_map_button_button_up():
	settings_singleton.level_to_load = set_map
	get_tree().change_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.


func _on_scores_button_button_up():
	var text = "TOP SCORES \nscore  name   time\n"
	var scores = settings_singleton.scores_to_str()
	scores = scores.replace(",","   ")
	if (scores == ""):
		scores = "no data yet..."
	$scores_panel/RichTextLabel.text = text + scores
	$scores_panel.visible = true

func _on_close_credits_button_button_up():
	$credits_panel.visible = false


func _on_close_scores_button_button_up():
	$scores_panel.visible = false


func _on_tutorial_check_toggled(button_pressed):
	settings_singleton.tutorial_on = button_pressed
