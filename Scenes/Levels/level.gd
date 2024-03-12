extends Node3D

@onready var camera = %MainCamera

var collider = null
var coin_there = false
var coin = null

@onready var coin_scene = preload("res://Scenes/Models/coin.tscn")
@onready var red = preload("res://Materials/red.tres")
@onready var yellow = preload("res://Materials/yellow.tres")

@onready var player_scene = preload("res://Scenes/Multiplayer/player.tscn")

@onready var objects_node = $Objects

func _ready():
	Global.camera = camera
	
	for i in Global.players:
		var current_player = player_scene.instantiate()
		current_player.name = str(Global.players[i].id)
		Global.camera.add_child(current_player)


@rpc("any_peer", "call_local")
func display_winner():
	$CanvasLayer.display_winner()
