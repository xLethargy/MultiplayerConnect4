extends CanvasLayer

var winner_colour

var spin_the_coin = false

@onready var coin = $Coin
@onready var red = preload("res://Materials/red.tres")
@onready var yellow = preload("res://Materials/yellow.tres")

func _process(delta):
	if spin_the_coin:
		coin.rotate_y(7 * delta)

func display_winner():
	if Global.winner == 1:
		winner_colour = "RED IS THE WINNER"
		$Label.label_settings.font_color = Color.RED
	elif Global.winner == 2:
		winner_colour = "YELLOW IS THE WINNER"
		$Label.label_settings.font_color = Color.YELLOW
	
	if Global.patterns > 1:
		winner_colour = winner_colour + "
		WITH " + str(Global.patterns) + " PATTERNS TOO!"
	$Label.text = winner_colour
	$Label.show()
	$Button.show()
	$Coin.show()
	spin_the_coin = true
	if Global.players_turn_no_change == 1:
		coin.get_child(0).set_surface_override_material(0, red)
	elif Global.players_turn_no_change == 2:
		coin.get_child(0).set_surface_override_material(0, yellow)


func _on_button_pressed():
	get_tree().reload_current_scene()
	Global.reset_globals()
