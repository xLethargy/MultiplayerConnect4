extends CanvasLayer

@export var address = "127.0.0.1"
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


# Called on the server and clients when someone connects
func peer_connected(id):
	print ("player connected " + str(id))

# Called on the server and clients when someone disconnects
func peer_disconnected(id):
	print ("player disconnected " + str(id))

# Called only from clients when a client connects to a server
func connected_to_server():
	print ("connected to server")
	send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

# Called only from clients when connection fails
func connection_failed():
	print ("connection failed")

func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print ("cannot host: ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print ("Waiting for players...")
	send_player_information($LineEdit.text, multiplayer.get_unique_id())


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # COMPRESSION MUST BE THE SAME AS SERVER AND CLIENT
	multiplayer.set_multiplayer_peer(peer)


func _on_start_pressed():
	if is_multiplayer_authority():
		start_game.rpc()


@rpc("any_peer")
func send_player_information(name, id):
	if !Global.players.has(id):
		Global.players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in Global.players:
			send_player_information.rpc(Global.players[i].name, i)


@rpc("any_peer", "call_local")
func start_game():
	get_tree().change_scene_to_file("res://Scenes/Levels/level.tscn")
