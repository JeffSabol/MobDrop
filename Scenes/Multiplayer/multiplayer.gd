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
	$MainMenuMusic.stop()
	$BlueMusic.play()
	peer.create_client("104.248.123.73", 35000)
	multiplayer.multiplayer_peer = peer

	# Deactivate main menu camera
	var current_camera = get_viewport().get_camera_2d()
	if current_camera:
		current_camera.enabled = false
	
	# Instantiate the player scene on the client side
	var player = player_scene.instantiate()
	player.name = str(multiplayer.get_unique_id()) # Name the player using their unique ID
	player.position = Vector2(-1800, 858)

	# Add the player to the scene
	call_deferred("add_child", player)

	# Create and assign the camera to the player
	var player_camera = Camera2D.new()
	player_camera.enabled = true # Enable the camera before making it current
	player.add_child(player_camera)

	# Ensure the camera is inside the scene tree before calling make_current()
	player_camera.call_deferred("make_current")

	# Remove the HUD join button
	$Join.queue_free()

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

func _on_door_1_body_entered(body):
	# Silly hack to detect if it's a player. Other nodes besides the player all have letters in their names.
	if not has_no_numbers(body.name):
		$BlueMusic.stop()
		$RedMusic.play()
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(-1788, 1625)

func has_no_numbers(input_string: String) -> bool:
	return input_string.find("0") == -1 and input_string.find("1") == -1 and input_string.find("2") == -1 and input_string.find("3") == -1 and input_string.find("4") == -1 and input_string.find("5") == -1 and input_string.find("6") == -1 and input_string.find("7") == -1 and input_string.find("8") == -1 and input_string.find("9") == -1

# What is DRY? Do Repeat Yourself?
func _on_door_2_body_entered(body):
	if not has_no_numbers(body.name):
		$RedMusic.stop()
		$YellowMusic.play()
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(702, 2001)


func _on_door_3_body_entered(body):
	if not has_no_numbers(body.name):
		$YellowMusic.stop()
		$EarthMusic.play()
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(2658, 1404)


func _on_door_4_body_entered(body):
	if not has_no_numbers(body.name):
		$EarthMusic.stop()
		$BlueMusic.play()
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(-1752, 3828)


func _on_door_5_body_entered(body):
	if not has_no_numbers(body.name):
		$BlueMusic.stop()
		$RedMusic.play()
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(846, 3262)


func _on_door_6_body_entered(body):
	if not has_no_numbers(body.name):
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(2483, 3322)


func _on_door_7_body_entered(body):
	if not has_no_numbers(body.name):
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		# Convert to NodePath to properly grab the player node
		var player_node_path = NodePath(body.name) 
		world.get_node(player_node_path).position = Vector2(727, 5481)
