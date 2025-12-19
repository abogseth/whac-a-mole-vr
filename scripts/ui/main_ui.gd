extends CanvasLayer

signal play_pressed
signal stats_pressed
signal settings_pressed
signal quit_pressed

@onready var play_button = $MainMenu/ColorRect/MarginContainer/VBoxContainer/Play
@onready var stats_button = $MainMenu/ColorRect/MarginContainer/VBoxContainer/Stats
@onready var settings_button = $MainMenu/ColorRect/MarginContainer/VBoxContainer/Settings
@onready var quit_button = $MainMenu/ColorRect/MarginContainer/VBoxContainer/Quit

# Connects signals to the menu buttons
func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	stats_button.pressed.connect(_on_stats_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	


func _on_play_pressed():
	emit_signal("play_pressed")

func _on_stats_pressed():
	emit_signal("stats_pressed")

func _on_settings_pressed():
	emit_signal("settings_pressed")

func _on_quit_pressed():
	emit_signal("quit_pressed")
