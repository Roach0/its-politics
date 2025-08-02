extends Node

signal lobby_entered
signal lobby_members_changed
signal owner_left
signal lobby_list_refreshed(lobby_buttons: Array[Button])
signal game_started(players: Array[Player])

const PACKET_READ_LIMIT: int = 32

var lobby_id: int = 0
var lobby_members: Array[Dictionary] = []
var lobby_members_max: int = 10
var lobby_name: String = "Victor Test - Game1"
var steam_username: String = ""
var channel: int = 0
var max_messages: int = 10

func _ready() -> void:
	Steam.join_requested.connect(_on_lobby_join_requested)
	Steam.lobby_created.connect(_on_lobby_created)
	# Steam.lobby_data_update.connect(_on_lobby_data_update)
	# Steam.lobby_invite.connect(_on_lobby_invite)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	Steam.persona_state_change.connect(_on_persona_change)
	Steam.network_messages_session_request.connect(_on_network_messages_session_request)
	Steam.network_messages_session_failed.connect(_on_network_messages_session_failed)
	# Check for command line arguments
	# check_command_line()

func _process(_delta) -> void:
	Steam.run_callbacks()

	# If the player is connected, read packets
	if lobby_id > 0:
		read_messages()

func create_lobby(lobby_type: Steam.LobbyType) -> void:
	print("creating lobby of type %s" % lobby_type)
	# Make sure a lobby is not already set
	if lobby_id == 0:
		Steam.createLobby(lobby_type, lobby_members_max)

func _on_lobby_created(success: Steam.Result, this_lobby_id: int) -> void:
	if success == 1:
		# Set the lobby ID
		lobby_id = this_lobby_id
		print("Created a lobby: %s" % lobby_id)
		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(lobby_id, true)

		# Set some lobby data
		Steam.setLobbyData(lobby_id, "name", lobby_name)

		# Allow P2P connections to fallback to being relayed through Steam if needed
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		print("Allowing Steam to be relay backup: %s" % set_relay)

		lobby_entered.emit()

func _on_open_lobby_list_pressed() -> void:
	# Set distance to worldwide
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)

	print("Requesting a lobby list")
	Steam.requestLobbyList()

func _on_lobby_match_list(these_lobbies: Array) -> void:
	var lobby_buttons: Array[Button] = []
	lobby_list_refreshed.emit(lobby_buttons)
	for this_lobby in these_lobbies:
		# Pull lobby data from Steam, these are specific to our example
		var this_lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		if this_lobby_name != lobby_name:
			continue

		# Get the current number of members
		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)

		print("Lobby %s: %s - %s Player(s)" % [this_lobby, this_lobby_name, lobby_num_members])

		# Create a button for the lobby
		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s - %s Player(s)" % [this_lobby, this_lobby_name, lobby_num_members])
		lobby_button.set_size(Vector2(800, 50))
		lobby_button.set_name("lobby_%s" % this_lobby)
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))

		# Add the new lobby to the list
		lobby_buttons.append(lobby_button)

	lobby_list_refreshed.emit(lobby_buttons)

func join_lobby(this_lobby_id: int) -> void:
	print("Attempting to join lobby %s" % lobby_id)

	# Clear any previous lobby members lists, if you were in a previous lobby
	lobby_members.clear()

	# Make the lobby join request to Steam
	Steam.joinLobby(this_lobby_id)

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	print("Lobby joined: %s" % this_lobby_id)
	# If joining was successful
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		print("Lobby joined successfully")
		# Set this lobby ID as your lobby ID
		lobby_id = this_lobby_id

		# Get the lobby members
		get_lobby_members()

		# Make the initial handshake
		make_p2p_handshake()

		lobby_entered.emit()

	# Else it failed for some reason
	else:
		# Get the failure reason
		var fail_reason: String

		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."

		print("Failed to join this chat room: %s" % fail_reason)

		#Reopen the lobby list
		_on_open_lobby_list_pressed()

func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	# Get the lobby owner's name
	var owner_name: String = Steam.getFriendPersonaName(friend_id)

	print("Joining %s's lobby..." % owner_name)

	# Attempt to join the lobby
	join_lobby(this_lobby_id)

func get_lobby_members() -> void:
	# Clear your previous lobby list
	lobby_members.clear()

	# Get the number of members from this lobby from Steam
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)

	# Get the data of these players from Steam
	for this_member in range(0, num_of_members):
		# Get the member's Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)

		# Get the member's Steam name
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)

		# Add them to the list
		lobby_members.append({"steam_id": member_steam_id, "steam_name": member_steam_name})

	print("Lobby members: %s" % lobby_members)
	lobby_members_changed.emit()

# A user's information has changed
func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if lobby_id > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)

		# Update the player list
		get_lobby_members()

func make_p2p_handshake() -> void:
	print("Sending P2P handshake to the lobby")

	send_message({"message": "handshake"})

func _on_lobby_chat_update(_this_lobby_id: int, change_id: int, _making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var changer_name: String = Steam.getFriendPersonaName(change_id)

	# If a player has joined the lobby
	if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		print("%s has joined the lobby." % changer_name)

	# Else if a player has left the lobby
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		print("%s has left the lobby." % changer_name)

		# Check if the person who left was the owner
		if change_id == Steam.getLobbyOwner(lobby_id):
			print("The owner has left the lobby!")
			owner_left.emit()

	# Else if a player has been kicked
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		print("%s has been kicked from the lobby." % changer_name)

	# Else if a player has been banned
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		print("%s has been banned from the lobby." % changer_name)

	# Else there was some unknown change
	else:
		print("%s did... something." % changer_name)

	# Update the lobby now that a change has occurred
	get_lobby_members()

func leave_lobby() -> void:
	# If in a lobby, leave it
	if lobby_id != 0:
		# Send leave request to Steam
		Steam.leaveLobby(lobby_id)

		# Wipe the Steam lobby ID then display the default lobby ID and player list title
		lobby_id = 0

		# Close session with all users
		for this_member in lobby_members:
			# Make sure this isn't your Steam ID
			if this_member['steam_id'] != SteamAuthManager.steam_id:
				# Close the P2P session using the Networking class
				Steam.closeP2PSessionWithUser(this_member['steam_id'])

		# Clear the local lobby list
		lobby_members.clear()

func _on_network_messages_session_request(remote_id: int) -> void:
	# Get the requester's name
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	print("%s is requesting a P2P session" % this_requester)

	# Accept the P2P session; can apply logic to deny this request if needed
	Steam.acceptSessionWithUser(remote_id)

	# Make the initial handshake
	make_p2p_handshake()


func read_messages() -> void:
	# The maximum number of messages you want to read per call
	var messages: Array = Steam.receiveMessagesOnChannel(channel, max_messages)

	# There is a packet
	for message in messages:
		if message.is_empty() or message == null:
			print("WARNING: read an empty message with non-zero size!")
		else:
			message.payload = bytes_to_var(message.payload)
			# Get the remote user's ID
			var message_sender: int = message.identity

			# Print the packet to output
			print("Message Payload: %s" % message.payload)
			print("Message Sender: %s" % message_sender)

			handle_message(message_sender, message.payload)

func handle_message(sender_id: int, payload: Dictionary) -> void:
	print("Message: %s" % payload)
	match payload.message:
		"start_game":
			if is_owner(sender_id):
				var players: Array[Player] = get_players()
				game_started.emit(players)
			else:
				print("Non-owner tried to start game. Ignoring.")

func send_message(packet_data: Dictionary) -> void:
	# Set the send_type and channel
	var send_type: int = Steam.NETWORKING_SEND_RELIABLE_NO_NAGLE

	# Create a data array to send the data through
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data))

	if lobby_members.size() > 1:
		# Loop through all members that aren't you
		for this_member in lobby_members:
			if this_member['steam_id'] != SteamAuthManager.steam_id:
				Steam.sendMessageToUser(this_member['steam_id'], this_data, send_type, channel)

func _on_network_messages_session_failed(_steam_id: int, _session_error: int, _state: int, debug_msg: String) -> void:
	print(debug_msg)

func is_owner(sender_id: int = 0) -> bool:
	var current_owner: int = Steam.getLobbyOwner(lobby_id)
	if sender_id == 0:
		return current_owner == SteamAuthManager.steam_id

	return sender_id == current_owner

func start_game() -> void:
	if is_owner():
		send_message({"message": "start_game"})
		var players: Array[Player] = get_players()
		game_started.emit(players)
	else:
		print("You are not the owner of the lobby")

func get_players() -> Array[Player]:
	var players: Array[Player] = []
	for member in lobby_members:
		players.append(Player.new(member['steam_id'], member['steam_name']))
	print("Players: %s" % players)
	return players
