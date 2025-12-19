extends Node

# Game settings (editable in settings)
var difficulty := 2
var playTime := 20

# Runtime state
var hammers_picked_up := 0

# TODO: Må nok endres
func reset_game():
	hammers_picked_up = 0
