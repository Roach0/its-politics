extends Node

func _ready() -> void:
	SteamNetworkManager.game_started.connect(_on_game_started)

func _on_game_started(players: Array[Player]) -> void:
	print("Game started with %s players" % players.size())
	var board_ui_scene: PackedScene = preload("res://features/board/board_ui.tscn")
	var board_ui_instance: Node = board_ui_scene.instantiate()
	add_child(board_ui_instance)
	board_ui_instance.set_players(players)
	TurnManager.start_game(players)

	$MultiplayerUi.hide()
