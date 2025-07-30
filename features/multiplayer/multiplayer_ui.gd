extends Control

var lobby_list_ui: Control
var lobby_ui: Control

func _ready() -> void:
	SteamNetworkManager.lobby_entered.connect(_on_enter_lobby)

	# Preload scenes for better performance
	var lobby_list_scene = preload("res://features/multiplayer/lobby_list_ui.tscn")
	var lobby_ui_scene = preload("res://features/multiplayer/lobby_ui.tscn")

	# Instance both UIs but only add the lobby list initially
	lobby_list_ui = lobby_list_scene.instantiate()
	lobby_ui = lobby_ui_scene.instantiate()
	lobby_ui.leave_lobby.connect(_on_leave_lobby)
	lobby_ui.hide()

	$Margin.add_child(lobby_list_ui)
	$Margin.add_child(lobby_ui)

func _on_enter_lobby() -> void:
	print("Lobby joined %s" % SteamNetworkManager.lobby_id)

	# Switch UIs by removing one and adding the other
	lobby_list_ui.hide()
	lobby_ui.show()

	lobby_ui.initialize(SteamNetworkManager.lobby_name)

func _on_leave_lobby() -> void:
	SteamNetworkManager.leave_lobby()

	# Switch UIs by removing one and adding the other
	lobby_list_ui.show()
	lobby_ui.hide()
