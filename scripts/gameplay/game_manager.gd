extends Node3D

@export var mole_scenes: Array[PackedScene]
@export var holes: Array[Node3D]   # positions of holes in the world

signal start_game
signal end_game
signal update_score

var moles := []
var mole_stats
var mole_hit_time
var mole_hit_rate
var timer: Timer
var pop_timer: Timer
var score = 0
var up_time
var pop_interval

func _ready():
	# Instantiate a mole for each hole
	for hole in holes:
		var mole = mole_scenes[0].instantiate()
		hole.add_child(mole)
		mole.position = Vector3.ZERO
		moles.append(mole)
	
	# Connects signals to each mole
	for mole in moles:
		mole.connect("mole_down", _on_mole_down)
		mole.connect("update_score", _on_mole_hit_update_score)

# Pressing play sends signal to main to change menu and starts the game
func on_play_pressed():
	print("Trying to disable pointers")
	emit_signal("start_game")
	_play_game()

# When a mole goes down this function stores the time it was up for,
# and stores it in the moles stats
func _on_mole_down(mole, duration):
	var mole_index = holes.find(mole.get_parent())
	print("Mole nr: ", mole_index, " Time: ", duration)
	mole_hit_time[mole_index].append(duration)

# When a mole is hit, this function updates the score in the game manager,
# sends a signal to update the score on the score board and
# updates the mole_hit_rate table
func _on_mole_hit_update_score(mole):
	print("Update score from game manager")
	var mole_index = holes.find(mole.get_parent())
	mole_hit_rate[mole_index].append(true)
	score += 1
	emit_signal("update_score", 1)

# Starts the game by starting a timer
func _play_game():
	print("In function play game, game should start")
	timer = Timer.new()
	timer.wait_time = Settings.playTime
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

	# Makes tables for holding hit_times and hit_rates for each mole
	mole_hit_time = []
	mole_hit_rate = []
	for i in moles.size():
		mole_hit_time.append([])
		mole_hit_rate.append([])
	
	print("Difficulty: ", Settings.difficulty)
	print("Play time: ", Settings.playTime)
	
	# Set difficulty for game
	match Settings.difficulty:
		0:
			pop_interval = 5
			up_time = 3
			print("Easy")
		1:
			pop_interval = 3
			up_time = 2
			print("Medium")
		2:
			pop_interval = 0.5
			up_time = 1
			print("Hard")
		_:
			pop_interval = 5 # Default case
			up_time = 3
			print("Default")

	_start_pop_timer()

# Stops the game when time has ran out
func _on_timer_timeout():
	print("Timer is done")
	if pop_timer:
		pop_timer.stop()
	
	for mole in moles:
		if mole.is_up:
			mole.go_down()
	
	#for i in mole_hit_time.size():
		#print("Mole ", i, " with times: ")
		#for time in mole_hit_time[i]:
			#print(time)
	var game_stats: Dictionary = calculate_statistics()
	
	# What to do when the playTime has run out
	emit_signal("end_game", game_stats)

# Starts a timer for an individual mole
func _start_pop_timer():
	pop_timer = Timer.new()
	pop_timer.wait_time = pop_interval
	pop_timer.one_shot = false
	add_child(pop_timer)
	pop_timer.start()
	# Calls on_pop_timer_timeout when timer runs out
	pop_timer.timeout.connect(_on_pop_timer_timeout)

# Function that picks a mole to pop up
func _on_pop_timer_timeout():
	# Finds the moles that are down
	var down_moles := []
	for mole in moles:
		if not mole.is_up:
			down_moles.append(mole)
	if down_moles.size() == 0:
		return

	# Picks a random mole that is down
	var mole = down_moles[randi() % down_moles.size()]
	mole.go_up()

	# Schedule it to go down after random time
	await get_tree().create_timer(up_time).timeout
	# If mole is not hit, minus one point and update mole_hit_rate table 
	if mole.is_up:
		score -= 1
		emit_signal("update_score", -1)
		var mole_index = holes.find(mole.get_parent())
		mole_hit_rate[mole_index].append(false)
		mole.go_down()

func calculate_statistics():
	#print("Stats:")
	#print("Hit time:")
	var hit_time_array = []
	for i in range(mole_hit_time.size()):
		#print("Mole nr. ", i)
		var total = 0
		var average = "N/A"
		if mole_hit_time[i].size() > 0:
			for j in range(mole_hit_time[i].size()):
				total += mole_hit_time[i][j]
			var a = snapped(total / mole_hit_time[i].size(), 0.01)
			average = str(a, "s")
		#print("Average time: ", average)
		hit_time_array.append(average)
	
	var hit_rate_array = []
	#print("Hit rate:")
	for i in range(mole_hit_rate.size()):
		#print("Mole nr. ", i)
		var times_hit = 0
		var hit_rate = "N/A"
		if mole_hit_rate[i].size() > 0:
			for j in range(mole_hit_rate[i].size()):
				if mole_hit_rate[i][j] == true:
					times_hit += 1
			var hr = int((float(times_hit) / float(mole_hit_rate[i].size())) * 100)
			hit_rate = str(hr, "%")
		#print("Hit rate: ", hit_rate)
		hit_rate_array.append(hit_rate)
		
	var stats: Dictionary = {
		'difficulty': Settings.difficulty,
		'play_time': Settings.playTime,
		'points': score,
		'mole_time_array': hit_time_array,
		'mole_hit_rate_array': hit_rate_array,
		'timestamp': Time.get_datetime_string_from_system()
	}
		
	return stats
