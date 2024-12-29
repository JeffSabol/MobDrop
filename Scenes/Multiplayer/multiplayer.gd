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
	player.position = Vector2(850,-350)
	
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client("104.248.123.73", 35000)
	multiplayer.multiplayer_peer = peer

	# Deactivate main menu camera
	var current_camera = get_viewport().get_camera_2d()
	if current_camera:
		current_camera.enabled = false
	
	# Instantiate the player scene on the client side
	var player = player_scene.instantiate()
	player.name = str(multiplayer.get_unique_id()) # Name the player using their unique ID
	player.position = Vector2(850, -350)

	# Add the player to the scene
	call_deferred("add_child", player)

	# Create and assign the camera to the player
	var player_camera = Camera2D.new()
	player_camera.enabled = true # Enable the camera before making it current
	player.add_child(player_camera)

	# Ensure the camera is inside the scene tree before calling make_current()
	player_camera.call_deferred("make_current")

	# Remove the HUD join button
	$join.queue_free()

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


func _on_exit_pressed():
		get_tree().quit();
