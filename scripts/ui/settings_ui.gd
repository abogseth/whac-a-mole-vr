extends CanvasLayer

signal back_pressed

@onready var time_slider = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/PlayTimeSlider
@onready var difficulty_button = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/DifficultyOptionButton
@onready var back_button = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/BackButton
@onready var time_label = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/TimeLabel

# Sets values from settings
func _ready() -> void:
	time_slider.value = Settings.playTime
	time_label.text = str(Settings.playTime)
	difficulty_button.selected = Settings.difficulty
	back_button.pressed.connect(_on_back_pressed)


func _on_back_pressed():
	Settings.difficulty = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/DifficultyOptionButton.selected
	Settings.playTime = $SettingsMenu/ColorRect/MarginContainer/VBoxContainer/PlayTimeSlider.value
	print("playtime and difficulty ", Settings.playTime, " ", Settings.difficulty)
	emit_signal("back_pressed")
	

# Changes time label time displayed when slider value changes
func _on_play_time_slider_value_changed(value: float) -> void:
	Settings.playTime = int(value)
	time_label.text = str(int(value))
