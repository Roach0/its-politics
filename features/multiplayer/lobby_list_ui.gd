extends VBoxContainer

func _ready() -> void:
    SteamNetworkManager.lobby_list_refreshed.connect(_on_lobby_list_refreshed)

func _on_refresh_lobby_list_pressed() -> void:
    SteamNetworkManager._on_open_lobby_list_pressed()

func _on_create_lobby_pressed() -> void:
    SteamNetworkManager.create_lobby(Steam.LOBBY_TYPE_PUBLIC)

func _on_lobby_list_refreshed(lobby_buttons: Array[Button]) -> void:
    for child in $LobbyListContainer/LobbyList/Lobbies.get_children():
        child.queue_free()

    for lobby_button in lobby_buttons:
        $LobbyListContainer/LobbyList/Lobbies.add_child(lobby_button)