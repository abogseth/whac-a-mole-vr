extends Node3D

var main_menu_scene = preload("res://scenes/main_ui.tscn")
var statistics_scene = preload("res://scenes/statistics_ui.tscn")
var settings_scene = preload("res://scenes/settings_ui.tscn")
var score_scene = preload("res://scenes/score_board.tscn")
var score_board_instance: Node = null

@onready var game_manager = $GameManager
@onready var menu_screen = $MenuScreen
@onready var left_function_pointer = $XROrigin3D/LeftHandController/FunctionPointer
@onready var right_function_pointer = $XROrigin3D/RightHandController/FunctionPointer

# On ready it loads the main menu on the viewport and connects necessary signals 
func _ready():
	_load_ui(main_menu_scene)
	game_manager.connect("start_game", _start_game)
	game_manager.connect("end_game", _end_game)
	game_manager.connect("update_score", _on_update_score)

	

# Disables pointers when game is started
func _start_game():
	print("In main disabling pointers")
	left_function_pointer.visible = false
	right_function_pointer.visible = false

# Enables pointers when game is ended
func _end_game(statistics):
	StatisticsManager.save_statistics(statistics)
	left_function_pointer.visible = true
	right_function_pointer.visible = true
	
	_load_ui(main_menu_scene)

# Loads a selected scene in the viewport
func _load_ui(scene: PackedScene):
	menu_screen.scene = scene
	await get_tree().process_frame
	var ui_instance = menu_screen.get_scene_instance()
	if ui_instance == null:
		push_error("UI scene did not load into Viewport2Din3D!")
		return

	# Connect signals if they exist
	if ui_instance.has_signal("play_pressed"):
		ui_instance.connect("play_pressed", _on_play_pressed)
		
	if ui_instance.has_signal("settings_pressed"):
		ui_instance.connect("settings_pressed", _on_settings_pressed)

	if ui_instance.has_signal("back_pressed"):
		ui_instance.connect("back_pressed", _on_back_pressed)
		
	if ui_instance.has_signal("stats_pressed"):
		ui_instance.connect("stats_pressed", _on_stats_pressed)
	
	if ui_instance.has_signal("quit_pressed"):
		ui_instance.connect("quit_pressed", _on_quit_pressed)
		

# Updates score on the scoreboard when it gets a signal
func _on_update_score(point):
	print("Score should update, is in main")
	await get_tree().process_frame
	score_board_instance = menu_screen.get_scene_instance()
	score_board_instance.update_score(point)

# Loads settings scene
func _on_settings_pressed():
	_load_ui(settings_scene)

# Loads main menu scene
func _on_back_pressed():
	_load_ui(main_menu_scene)


func _on_stats_pressed():
	_load_ui(statistics_scene)

func _on_quit_pressed():
	_load_ui(settings_scene) # Må endres til å avslutte programmet

# Starts a game and loads the score scene
func _on_play_pressed():
	game_manager.on_play_pressed()
	_load_ui(score_scene)
