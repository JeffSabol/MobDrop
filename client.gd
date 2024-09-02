extends Node

var server_ip = "157.230.212.179"  # Replace with your server's IP address
var server_port = 35000
var player_id = -1  # Unique ID assigned by the server

var multiplayer_scene = preload("res://Scenes/Multiplayer/multiplayer_player.tscn")

func _ready():
	# Create the client
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(server_ip, server_port)
	if result != OK:
		print("Failed to connect to server.")
		return
	get_tree().get_multiplayer().multiplayer_peer = peer
	
	print("Connected to server at %s on port %d" % [server_ip, server_port])
	
	# Connect signals
	peer.connect("peer_connected", Callable(self, "_on_peer_connected"))
	peer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

func _on_peer_connected(id):
	print("Connected to server with ID: %d" % get_tree().get_multiplayer().get_unique_id())

func _on_peer_disconnected(id):
	print("Disconnected from server with ID: %d" % player_id)

func _process(delta):
	# Sync player state periodically
	if player_id != -1:
		send_player_state()

func send_player_state():
	var player_node = get_node("Player")
	if player_node:
		get_tree().get_multiplayer().rpc_unreliable("update_player_state", player_id, player_node.position, player_node.health)
	else:
		print("Player node not found.")

@rpc("any_peer")
func spawn_player(id):
	var player_instance = multiplayer_scene.instantiate()
	player_instance.name = str(id)
	get_node("Players").add_child(player_instance)
	if id == get_tree().multiplayer.get_unique_id():
		player_id = id

@rpc("any_peer")
func remove_player(id):
	var player_node = get_node("Players/" + str(id))
	if player_node:
		player_node.queue_free()

@rpc("any_peer")
func sync_player_state(id, position: Vector2, health: int):
	var player_node = get_node("Players/" + str(id))
	if player_node:
		player_node.position = position
		player_node.health = health
	else:
		print("Player node not found for ID: %s" % id)
		
