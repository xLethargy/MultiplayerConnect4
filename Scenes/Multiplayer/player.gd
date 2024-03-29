extends Node3D

var player_number = 0

var camera

var test_coin = null

var collider = null
var coin_there = false

var hover_coin_created = false

@onready var coin_scene = preload("res://Scenes/Models/hover_coin.tscn")
@onready var red = preload("res://Materials/red.tres")
@onready var yellow = preload("res://Materials/yellow.tres")

@onready var objects_node = get_tree().current_scene.objects_node
@onready var hover_coin = objects_node.get_child(0)

func _ready():
	camera = Global.camera
	if is_multiplayer_authority():
		player_number = 1
	else:
		player_number = 2


func _process(_delta):
	screen_point_to_ray()
	display_hover_coin()


func display_hover_coin():
	if Global.players_turn_no_change == player_number or Global.players.size() == 1:
		if Global.game_in_progress:
			%RayCast3D.collide_with_areas = true
			if %RayCast3D.get_collider() != null and %RayCast3D.get_collider().name == "InteractionArea":
				if %RayCast3D.get_collider().is_in_group("Interactable"):
					collider = %RayCast3D.get_collider()
					
					_change_hover_coin_position.rpc(Vector3(collider.get_parent().global_position.x, collider.get_parent().global_position.y + 0.25, collider.get_parent().global_position.z))
	
			elif %RayCast3D.get_collider() == null:
				_change_hover_coin_position.rpc(Vector3(0, -5, 0))


func screen_point_to_ray():
	if Global.players_turn_no_change == player_number or Global.players.size() == 1:
		%RayCast3D.enabled = true
		var mouse_position = get_viewport().get_mouse_position() #finds mouse location

		var dropPlane  = Plane(Vector3(0, 0, 1))
		var position3D = dropPlane.intersects_ray(camera.project_ray_origin(mouse_position),camera.project_ray_normal(mouse_position))
		
		if position3D != Vector3.ZERO:
			%RayCast3D.look_at(position3D)
		return Vector3()
		


func _input(event):
	if Global.players_turn_no_change == player_number or Global.players.size() == 1:
		if Global.game_in_progress:
			if event.is_action_pressed("interact"):
				if %RayCast3D.get_collider() != null and %RayCast3D.get_collider().name == "InteractionArea":
						if %RayCast3D.get_collider().is_in_group("Interactable"):
							collider = %RayCast3D.get_collider()
							collider.call_register_area()
							collider = null
							%RayCast3D.collide_with_areas = false
							
				elif collider != null:
					collider.call_unregister_area()
					


@rpc("any_peer", "call_local")
func _change_hover_coin_position(hover_coin_position):
	hover_coin.global_position = hover_coin_position
	if Global.players_turn_no_change == 1:
		hover_coin.get_node("Body").set_surface_override_material(0, yellow)
	elif Global.players_turn_no_change == 2:
		hover_coin.get_node("Body").set_surface_override_material(0, red)
