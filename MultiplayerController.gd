extends CanvasLayer

const port = 9999
@onready var address_entry = "127.0.0.1"

var player_count = 0

var enet_peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


# Called on the server and clients when someone connects
func peer_connected(id):
	player_count += 1
	print ("player connected " + str(id))

# Called on the server and clients when someone disconnects
func peer_disconnected(id):
	player_count -= 1
	print ("player disconnected " + str(id))

# Called only from clients when a client connects to a server
func connected_to_server():
	player_count += 1
	print ("connected to server")
	send_player_information.rpc_id(1, multiplayer.get_unique_id())

# Called only from clients when connection fails
func connection_failed():
	print ("connection failed")

func _on_host_pressed():
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	print ("Waiting for players...")
	send_player_information(multiplayer.get_unique_id())
	
	upnp_setup()


func _on_join_pressed():
	enet_peer.create_client(address_entry, port)
	multiplayer.multiplayer_peer = enet_peer


func _on_start_pressed():
	if is_multiplayer_authority():
		start_game.rpc()


@rpc("any_peer")
func send_player_information(id):
	if !Global.players.has(id):
		Global.players[id] = {
			"id": id,
			"score": 0,
			"number": player_count
		}
	
	if multiplayer.is_server():
		for i in Global.players:
			send_player_information.rpc(i)


@rpc("any_peer", "call_local")
func start_game():
	Global.change_scene()


func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")
	
	var map_result = upnp.add_port_mapping(port)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print ("Success! Join Address: %s" % upnp.query_external_address())
