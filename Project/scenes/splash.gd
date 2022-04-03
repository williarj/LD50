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


func _on_set_map_button_button_up():
	settings_singleton.level_to_load = "res://data/maps/map1.txt"
	get_tree().change_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.


func _on_scores_button_button_up():
	var text = "TOP SCORES:\n"
	var scores = settings_singleton.scores_to_str()
	if (scores == ""):
		scores = "no data yet..."
	$scores_panel/RichTextLabel.text = text + scores
	$scores_panel.visible = true


func _on_settings_node_close():
	pass # Replace with function body.


func _on_settings_node_lower_music():
	#print("music change")
	settings_singleton.music_level = (settings_singleton.music_level - 1 + 5) % 5
	if settings_singleton.music_level == 0:
		$music.playing = false
	elif settings_singleton.music_level == 4:
		$music.playing = true
	var music_bus = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus, -(10*(4-settings_singleton.music_level)))
	pass # Replace with function body.


func _on_settings_node_mute_sfx():
	pass # Replace with function body.


func _on_close_credits_button_button_up():
	$credits_panel.visible = false


func _on_close_scores_button_button_up():
	$scores_panel.visible = false
