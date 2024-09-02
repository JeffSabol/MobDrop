extends Node2D
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

 
# TODO uncomment this code when exporting to server
#func _ready():
	#if get_tree().get_multiplayer().is_server():
		#print("Creating a default server peer so others can communicate")
		#peer.create_server(35000)
		#multiplayer.multiplayer_peer = peer
		#multiplayer.peer_connected.connect(_add_player)
		#_add_player()
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
 
func _on_join_pressed():
	peer.create_client("157.230.212.179", 35000)
	multiplayer.multiplayer_peer = peer
