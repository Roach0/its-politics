extends VBoxContainer

signal leave_lobby

func _ready() -> void:
	SteamNetworkManager.lobby_members_changed.connect(_on_lobby_members_changed)

func _on_lobby_members_changed() -> void:
	print("Lobby members changed")
	for child in $PlayersPanel/PlayerList.get_children():
		child.queue_free()

	for member in SteamNetworkManager.lobby_members:
		var lobby_member: RichTextLabel = RichTextLabel.new()
		lobby_member.text = member.steam_name
		lobby_member.fit_content = true
		$PlayersPanel/PlayerList.add_child(lobby_member)

func initialize(lobby_name: String) -> void:
	$LobbyName.text = lobby_name

func _on_back_button_pressed() -> void:
	leave_lobby.emit()
