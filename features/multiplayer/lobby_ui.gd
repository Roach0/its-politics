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
		if SteamNetworkManager.is_owner(member.steam_id):
			lobby_member.text += " (Owner)"
		lobby_member.fit_content = true
		$PlayersPanel/PlayerList.add_child(lobby_member)

	# if SteamNetworkManager.is_owner():
	# 	if SteamNetworkManager.lobby_members.size() > 1:
		$ButtonContainer/StartButton.disabled = false
	# 	else:
	#       $ButtonContainer/StartButton.disabled = true

func initialize(lobby_name: String) -> void:
	$LobbyName.text = lobby_name

func _on_back_button_pressed() -> void:
	leave_lobby.emit()

func _on_start_button_pressed() -> void:
	SteamNetworkManager.start_game()
