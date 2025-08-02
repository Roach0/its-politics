extends Node

func _ready() -> void:
	SteamNetworkManager.game_started.connect(_on_game_started)

func _on_game_started() -> void:
	print("Game started")
	var board_scene: PackedScene = preload("res://features/board/board.tscn")
	var board_instance: Node = board_scene.instantiate()
	add_child(board_instance)

	$MultiplayerUi.hide()
