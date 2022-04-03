extends Node2D

signal lower_music()
signal close()
signal mute_sfx()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var music_level = 4 #4 = max, 0 = mute
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_close_button_button_up():
	emit_signal("close")


func _on_mute_sfx_button_button_up():
	emit_signal("mute_sfx")


func _on_mute_music_button_button_up():
	emit_signal("lower_music")
