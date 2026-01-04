extends CanvasLayer

@onready var game_chooser = $StatsMenu/ColorRect/VBoxContainer/GameChooser
@onready var timestamp_label = $StatsMenu/ColorRect/VBoxContainer/TopStats/TimestampLabel
@onready var difficulty_label = $StatsMenu/ColorRect/VBoxContainer/TopStats/DifficultyLabel
@onready var play_time_label = $StatsMenu/ColorRect/VBoxContainer/TopStats/PlayTimeLabel
@onready var points_label = $StatsMenu/ColorRect/VBoxContainer/TopStats/PointsLabel
@onready var hit_rates_box = $StatsMenu/ColorRect/VBoxContainer/BottomStats/HitRatesBox
@onready var hit_times_box = $StatsMenu/ColorRect/VBoxContainer/BottomStats/HitTimesBox
@onready var back_button = $StatsMenu/ColorRect/VBoxContainer/BackButton
var all_game_stats

signal back_pressed

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	all_game_stats = StatisticsManager.games
	for i in StatisticsManager.games.size():
		var display_name = "Game " + str(i+1) + " (" + all_game_stats[i]["timestamp"] + ")"
		game_chooser.add_item(display_name, i)
	if !all_game_stats.is_empty():
		display_stats(all_game_stats[0])
		

func _on_back_pressed():
	emit_signal("back_pressed")

func display_stats(stats: Dictionary):
	timestamp_label.text = "Time: " + stats["timestamp"]
	difficulty_label.text = "Difficulty: " + str(stats["difficulty"])
	play_time_label.text = "Play Time: " + str(stats["play_time"]) + "s"
	points_label.text = "Points: " + str(stats["points"])

	# Clear old hit-rate entries
	clear_children(hit_rates_box)
	
	var mole_index = 0
	print("Hit rate:")
	for rate in stats["mole_hit_rate_array"]:
		mole_index += 1
		var label = Label.new()
		label.text = str(" M", mole_index, ":", str(rate))
		#print(str(" M", mole_index, ":", str(rate)))
		hit_rates_box.add_child(label)

	# Clear old hit-time entries
	clear_children(hit_times_box)
	
	print("Average time:")
	mole_index = 0
	for time in stats["mole_time_array"]:
		mole_index += 1
		var label = Label.new()
		label.text = str(" M", mole_index, ":", str(time))
		#print(str(" M", mole_index, ":", str(time)))
		hit_times_box.add_child(label)


func _on_game_chooser_item_selected(index: int) -> void:
	display_stats(all_game_stats[index])

func clear_children(node: Node):
	for c in node.get_children():
		c.queue_free()
