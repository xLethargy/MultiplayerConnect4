extends Node


var players_turn = 0:
	get:
		players_turn = (players_turn % 2) + 1
		players_turn_no_change = players_turn
		return players_turn

var players_turn_no_change = players_turn

var game_in_progress = true:
	set(value):
		game_in_progress = value
		

var winner = null:
	set(value):
		winner = players_turn_no_change
		print (winner)

var patterns = 0:
	set(value):
		patterns = value

func reset_globals():
	players_turn = 0
	players_turn_no_change = players_turn
	game_in_progress = true
	winner = null
	patterns = 0
