extends Node3D

# Arrays that stores the games
var games: Array = []

func save_statistics(statistics):
	games.append(statistics)

func get_all_statistics():
	return games
