extends Node

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@export var player_scene: PackedScene
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _on_host_pressed() -> void:
	if peer.create_server(25565) != OK:
		print("Error: Creating server")
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	canvas_layer.hide()

func _on_join_pressed() -> void:
	if peer.create_client("26.163.44.28", 25565) != OK:
		print("Error: Joining server.")
	multiplayer.multiplayer_peer = peer
	canvas_layer.hide()

func add_player(id:int = 1) -> void:
	var player: Node = player_scene.instantiate()
	player.set_multiplayer_authority(id)
	player.name = str(id)
	call_deferred("add_child", player)
