extends Node3D

@onready var interaction_area = $InteractionArea
@onready var coin_scene = preload("res://Scenes/Models/coin.tscn")

var column_one_coins = 0
var column_two_coins = 0
var column_three_coins = 0
var column_four_coins = 0
var column_five_coins = 0
var column_six_coins = 0
var column_seven_coins = 0

var space_landing = 0

var players_turn

@onready var red = preload("res://Materials/red.tres")
@onready var yellow = preload("res://Materials/yellow.tres")

@onready var board = self.owner

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")



func _on_interact():
	if Global.game_in_progress:
		_columns_stuff.rpc()
		
		if space_landing < 6:
			_spawn_coin.rpc()

func _coin_logic(column_coins_amount : int):
	space_landing = column_coins_amount
	column_coins_amount += 1
	return column_coins_amount


@rpc("any_peer", "call_local")
func _spawn_coin():
	if space_landing == 5:
			interaction_area.queue_free()
	
	var coin = coin_scene.instantiate()
	
	coin.space_landing = space_landing
	
	add_child(coin)
	
	if players_turn == 1:
		coin.body.set_surface_override_material(0, red)
	elif players_turn == 2:
		coin.body.set_surface_override_material(0, yellow)
	
	board.check_the_board()
	#coin.rpc("update_coin_position", space_landing)


@rpc("any_peer", "call_local")
func _columns_stuff():
	players_turn = Global.players_turn
	match self.name:
		"ColumnOne":
			board.coin_column_one[column_one_coins] = players_turn
			column_one_coins = _coin_logic(column_one_coins)
		"ColumnTwo":
			board.coin_column_two[column_two_coins] = players_turn
			column_two_coins = _coin_logic(column_two_coins)
		"ColumnThree":
			board.coin_column_three[column_three_coins] = players_turn
			column_three_coins = _coin_logic(column_three_coins)
		"ColumnFour":
			board.coin_column_four[column_four_coins] = players_turn
			column_four_coins = _coin_logic(column_four_coins)
		"ColumnFive":
			board.coin_column_five[column_five_coins] = players_turn
			column_five_coins = _coin_logic(column_five_coins)
		"ColumnSix":
			board.coin_column_six[column_six_coins] = players_turn
			column_six_coins = _coin_logic(column_six_coins)
		"ColumnSeven":
			board.coin_column_seven[column_seven_coins] = players_turn
			column_seven_coins = _coin_logic(column_seven_coins)
