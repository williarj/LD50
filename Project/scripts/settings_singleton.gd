extends Node
class_name settings_singleton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music_level = 4
var level_to_load = null
var sfx_on = true
var tutorial_on = true

var score_file = "user://scores.txt"
var scores = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_scores()
	print(scores)
	pass # Replace with function body.
	
# call this at the beginning of your game.
# Tests to see if the file exists and loads the contents if it does
func load_scores():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		for line in content.split("\n"):
			var sline = line.split(",")
			if (len(sline) > 1):
				scores.append([sline[0], sline[1]]) #[score, name]
		f.close()

func add_score(score, name=""):
	name = name.replace("\n","").replace(",","")
	scores.append([score, name])

func scores_to_str():
	var content = ""
	scores.sort_custom(self, "compare_scores")
	for data in scores:
		content += str(data[0])+","+str(data[1])+"\n"
	return content

func compare_scores(a, b):
	return a[0] > b[0]

# call this at game end to store a new highscore
func save_scores():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_string(scores_to_str())
	f.close()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
