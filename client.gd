extends Node

var server_ip = "157.230.212.179"  # Replace with your server's IP address
var server_port = 35000
var player_id = -1  # Unique ID assigned by the server

func _ready():
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(server_ip, server_port)
	
	if result != OK:
		print("Failed to connect to server: %s" % result)
		return
	
	get_tree().get_multiplayer().set_multiplayer_peer(peer)
	print("Connected to server at %s on port %d" % [server_ip, server_port])
	
	# Connect signals directly to the MultiplayerAPI
	var multiplayer = get_tree().get_multiplayer()
	multiplayer.connect("peer_connected", Callable(self, "_on_peer_connected"))
	multiplayer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
	multiplayer.connect("data_received", Callable(self, "_on_data_received"))
	
	# Poll for incoming packets
	var multiplayer_peer = get_tree().get_multiplayer().get_multiplayer_peer()
	if multiplayer_peer.get_packet_available():
		var packet = multiplayer_peer.get_packet()
		_on_data_received(packet)

func _on_peer_connected(id):
	print("Connected to server with ID: %d" % id)
	player_id = id  # Assign ID when connected

func _on_peer_disconnected(id):
	print("Disconnected from server with ID: %d" % id)

func _process(delta):
	if player_id != -1:
		send_player_state()

func send_player_state():
	var player_node = get_node("Player")
	if player_node:
		var state = {
			"id": player_id,
			"position": {
				"x": player_node.position.x,
				"y": player_node.position.y
			},
			"health": player_node.health
		}
		var packet = create_packet(state)
		var multiplayer = get_tree().get_multiplayer()
		multiplayer.get_multiplayer_peer().put_packet(packet)
	else:
		print("Player node not found.")

func create_packet(state):
	var json = JSON.new()
	var state_string = json.stringify(state)
	if state_string.is_empty():
		print("Failed to serialize state to JSON.")
	return to_byte_array(state_string)

func _on_data_received(packet):
	print("Data received: %s" % packet.get_string())
	var data = parse_packet(packet)
	update_player_state(data)


func parse_packet(packet):
	var json = JSON.new()
	var json_string = packet.get_string().utf8_to_string()
	var parse_result = json.parse(json_string)
	if parse_result.error != OK:
		print("Failed to parse JSON: %s" % parse_result.error)
		return {}
	return parse_result.result

func update_player_state(data):
	if not data.has("id") or not data.has("position") or not data.has("health"):
		print("Invalid data received: %s" % data)
		return
	
	var id = data["id"]
	var position = data["position"]
	var health = data["health"]
	
	# Update the position and health of the player with the given ID
	var player_node = get_node("Players/" + str(id))
	if player_node:
		player_node.position = Vector2(position["x"], position["y"])
		player_node.health = health
	else:
		print("Player node not found: %s" % id)

func to_byte_array(data):
	var buf = PackedByteArray()
	buf.append_array(data.to_utf8_buffer())
	return buf
