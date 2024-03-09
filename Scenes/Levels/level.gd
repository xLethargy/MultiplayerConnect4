extends Node3D

@onready var camera = %MainCamera

var collider = null
var coin_there = false
var coin = null

@onready var coin_scene = preload("res://Scenes/Models/coin.tscn")
@onready var red = preload("res://Materials/red.tres")
@onready var yellow = preload("res://Materials/yellow.tres")

@onready var player_scene = preload("res://Scenes/Multiplayer/player.tscn")

func _ready():
	for i in Global.players:
		var current_player = player_scene.instantiate()
		current_player.name = str(Global.players[i].id)
		add_child(current_player)


func _process(_delta):
	screen_point_to_ray()
	
#	if Global.game_in_progress:
#		if %RayCast3D.get_collider() != null and %RayCast3D.get_collider().name == "InteractionArea":
#			if %RayCast3D.get_collider().is_in_group("Interactable") and !coin_there:
#				collider = %RayCast3D.get_collider()
#				coin_there = true
#				coin = coin_scene.instantiate()
#				
#				collider.get_parent().add_child(coin)
#				
#				coin.freeze = true
#				
#				
#				if Global.players_turn_no_change == 1:
#					coin.body.set_surface_override_material(0, yellow)
#				elif Global.players_turn_no_change == 2:
#					coin.body.set_surface_override_material(0, red)
#				
#				collider.call_register_area()
#			elif (%RayCast3D.get_collider() != collider) and coin_there:
#				coin_there = false
#				coin.queue_free()
#				if collider != null:
#					collider.call_unregister_area()
#		elif %RayCast3D.get_collider() == null and coin_there:
#			coin_there = false
#			coin.queue_free()
#			if collider != null:
#				collider.call_unregister_area()
#	elif coin_there:
#		coin_there = false
#		coin.queue_free()


func screen_point_to_ray():
	var mouse_position = get_viewport().get_mouse_position() #finds mouse location

	var dropPlane  = Plane(Vector3(0, 0, 1))
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(mouse_position),camera.project_ray_normal(mouse_position))
	
	if position3D != Vector3.ZERO:
		%RayCast3D.look_at(position3D)
	return Vector3()


func _input(event):
	if Global.game_in_progress:
		if event.is_action_pressed("interact"):
			if %RayCast3D.get_collider() != null and %RayCast3D.get_collider().name == "InteractionArea":
					if %RayCast3D.get_collider().is_in_group("Interactable"):
						collider = %RayCast3D.get_collider()
						collider.call_register_area()
						
						if coin != null:
							if Global.players_turn_no_change == 1:
								coin.body.set_surface_override_material(0, red)
							elif Global.players_turn_no_change == 2:
								coin.body.set_surface_override_material(0, yellow)
			elif collider != null:
				collider.call_unregister_area()


@rpc("any_peer", "call_local")
func display_winner():
	$CanvasLayer.display_winner()
