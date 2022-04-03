extends Node2D
class_name sound_manager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var settings_singleton : settings_singleton
func _ready():
	settings_singleton = get_node("/root/SettingsSingleton")
	#copy the music settings from the singleton
	_on_settings_node_lower_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_correct_delivery(destination, type):
	$correct_delivery_sound.play()
	pass

func on_bad_delivery(destination, type_delivered, type_wanted):
	$bad_delivery_sound.play()
	pass

func on_source_depleted(source):
	$source_depleted_sound.play()
	pass

func on_sink_satisfied(sink):
	$sink_satisfied_sound.play()
	pass

func on_resource_spawn(type):
	$spawn_resource_sound.play()
	pass
	
func on_become_source(type):
	$spawn_source_sound.play()
	pass

func on_become_sink(type):
	$spawn_sink_sound.play()
	pass

func on_pollution(box):
	$pollution_sound.play()
	pass
	
func on_rotate_left(box):
	$rotate_left_sound.play()
	pass
	
func on_rotate_right(box):
	$rotate_right_sound.play()
	pass


func _on_settings_node_lower_music():
	print("music change")
	settings_singleton.music_level = (settings_singleton.music_level - 1 + 5) % 5
	if settings_singleton.music_level == 0:
		$music_player.playing = false
	elif settings_singleton.music_level == 4:
		$music_player.playing = true
	var music_bus = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus, -(10*(4-settings_singleton.music_level)))


func _on_settings_node_mute_sfx():
	settings_singleton.sfx_on = !settings_singleton.sfx_on
	var music_bus = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_mute(music_bus, !settings_singleton.sfx_on)
	
