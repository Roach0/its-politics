extends VBoxContainer

func _ready() -> void:
    SteamNetworkManager.lobby_list_ui = get_node("LobbyList/LobbyList/Lobbies")

func _on_refresh_lobby_list_pressed() -> void:
    SteamNetworkManager._on_open_lobby_list_pressed()

func _on_create_lobby_pressed() -> void:
    SteamNetworkManager.create_lobby(Steam.LOBBY_TYPE_PUBLIC)