extends CanvasLayer

var score = 0
var game_time = Settings.playTime
var time_left
@onready var clock_label = $Control/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/DisplayClockLabel
@onready var score_label = $Control/ColorRect/MarginContainer/VBoxContainer/DisplayScoreLabel

# Starts countdown
func _ready():
	time_left = game_time
	clock_label.text = str(int(time_left))
	set_process(true)  # enable _process

func _process(delta):
	# Decrease time each frame
	if time_left > 0:
		time_left -= delta
		if time_left < 0:
			time_left = 0
		clock_label.text = str(int(time_left))

# Updates score displayed
func update_score(point):
	score += point
	score_label.text = str(score)
