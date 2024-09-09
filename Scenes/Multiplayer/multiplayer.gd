# Jeff Sabol

extends Node2D

var peer := ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

# Uncomment and use this function when running as a server
#func _ready():
	#if get_tree().get_multiplayer().is_server():
		#print("Creating a default server peer so others can communicate")
		#peer.create_server(35000)
		#multiplayer.multiplayer_peer = peer
		#multiplayer.peer_connected.connect(_add_player)
		#multiplayer.peer_disconnected.connect(_on_player_disconnected)

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client("157.230.212.179", 35000)
	multiplayer.multiplayer_peer = peer

@rpc("any_peer")
func _on_player_disconnected(id):
	print("Player id left: " + str(id))

	# Remove the player node on the server
	if get_tree().get_multiplayer().is_server():
		var player = get_node_or_null(str(id))
		if player:
			player.queue_free()

		# Notify all clients to remove this player node as well
		rpc("remove_player_on_clients", id)

@rpc("call_local")
func remove_player_on_clients(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()
		print("Removed player node with id: " + str(id) + " on client")
