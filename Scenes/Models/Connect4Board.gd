extends StaticBody3D

var coin_column_one : Array = [0, 0, 0, 0, 0, 0]
var coin_column_two : Array = [0, 0, 0, 0, 0, 0]
var coin_column_three : Array = [0, 0, 0, 0, 0, 0]
var coin_column_four : Array = [0, 0, 0, 0, 0, 0]
var coin_column_five : Array = [0, 0, 0, 0, 0, 0]
var coin_column_six : Array = [0, 0, 0, 0, 0, 0]
var coin_column_seven : Array = [0, 0, 0, 0, 0, 0]

var coin_position_board = [coin_column_one, coin_column_two, coin_column_three, coin_column_four, coin_column_five, coin_column_six, coin_column_seven]


func check_the_board():
	# grabs coin_position_board[i] which is each column
	for i in range(len(coin_position_board) - 3):
		for j in range(len(coin_position_board[i]) - 3):
			# horizontal check
			if coin_position_board[i][j] != 0 and (coin_position_board[i][j] == coin_position_board[i + 1][j]) and (coin_position_board[i][j] == coin_position_board[i + 2][j]) and (coin_position_board[i][j] == coin_position_board[i + 3][j]):
				print ("connect 4 horizontal ", Global.players_turn_no_change)
				Global.game_in_progress = false
				Global.winner = Global.players_turn_no_change
				Global.patterns += 1
				get_tree().current_scene.display_winner.rpc()
			elif coin_position_board[i][j + 3] != 0 and (coin_position_board[i][j + 3] == coin_position_board[i + 1][j + 3]) and (coin_position_board[i][j + 3] == coin_position_board[i + 2][j + 3]) and (coin_position_board[i][j + 3] == coin_position_board[i + 3][j + 3]):
				print ("connect 4 horizontal ", Global.players_turn_no_change)
				Global.game_in_progress = false
				Global.winner = Global.players_turn_no_change
				Global.patterns += 1
				get_tree().current_scene.display_winner.rpc()
			
			# vertical check
			if coin_position_board[i][j] != 0 and (coin_position_board[i][j] == coin_position_board[i][j + 1]) and (coin_position_board[i][j] == coin_position_board[i][j + 2]) and (coin_position_board[i][j] == coin_position_board[i][j + 3]):
				print ("connect 4 vertical ", Global.players_turn_no_change)
				Global.game_in_progress = false
				Global.winner = Global.players_turn_no_change
				Global.patterns += 1
				get_tree().current_scene.display_winner.rpc()
			elif i != 0:
				if coin_position_board[i + 3][j] != 0 and (coin_position_board[i + 3][j] == coin_position_board[i + 3][j + 1]) and (coin_position_board[i + 3][j] == coin_position_board[i + 3][j + 2]) and (coin_position_board[i + 3][j] == coin_position_board[i + 3][j + 3]):
					print ("connect 4 vertical ", Global.players_turn_no_change)
					Global.game_in_progress = false
					Global.winner = Global.players_turn_no_change
					Global.patterns += 1
					get_tree().current_scene.display_winner.rpc()
			
			# diagonal check
			if coin_position_board[i][j] != 0 and (coin_position_board[i][j] == coin_position_board[i + 1][j + 1]) and (coin_position_board[i][j] == coin_position_board[i + 2][j + 2]) and (coin_position_board[i][j] == coin_position_board[i + 3][j + 3]):
				print ("connect 4 diagonaly positive ", Global.players_turn_no_change)
				Global.game_in_progress = false
				Global.winner = Global.players_turn_no_change
				Global.patterns += 1
				get_tree().current_scene.display_winner.rpc()
			
			if coin_position_board[i][j + 3] != 0 and (coin_position_board[i][j + 3] == coin_position_board[i + 1][j + 2]) and (coin_position_board[i][j + 3] == coin_position_board[i + 2][j + 1]) and (coin_position_board[i][j + 3] == coin_position_board[i + 3][j]):
				print ("connect 4 diagonaly negative ", i, " ", j)
				Global.game_in_progress = false
				Global.winner = Global.players_turn_no_change
				Global.patterns += 1
				get_tree().current_scene.display_winner.rpc()
			
