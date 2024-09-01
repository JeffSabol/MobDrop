extends Node

var server_ip = "157.230.212.179"  # Replace with your server's IP address
var server_port = 35000

func _ready():
	# Create a new ENet networked multiplayer instance
	var peer = ENetMultiplayerPeer.new()
	
	# Try to connect to the server on the specified IP and port
	var result = peer.create_client(server_ip, server_port)
	
	if result != OK:
		print("Failed to connect to server: ", result)
		return
	
	# Set up the MultiplayerAPI to use the network peer
	get_tree().get_multiplayer().set_multiplayer_peer(peer)
	print("Connected to server at ", server_ip, " on port ", server_port)

	# Connect to the network peer signals to handle server responses
	get_tree().get_multiplayer().connect("peer_connected", Callable(self, "_on_peer_connected"))
	get_tree().get_multiplayer().connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

# Handle server responses
func _on_peer_connected(id):
	print("Connected to server with ID: ", id)
	# You can send data or perform additional setup here

func _on_peer_disconnected(id):
	print("Disconnected from server with ID: ", id)
	# Handle disconnection logic here

# Example method to call an RPC on the server
@rpc
func move_player(position: Vector2):
	# Send player position to the server
	print("Sending player position to server: ", position)
