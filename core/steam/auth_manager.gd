extends Node

var steam_id: int = 0
var auth_ticket : Dictionary = {}
var client_auth_tickets : Array[Dictionary] = []

func _ready() -> void:
	Steam.get_auth_session_ticket_response.connect(_on_get_auth_session_ticket_response)
	Steam.validate_auth_ticket_response.connect(_on_validate_auth_ticket_response)
	auth_ticket = Steam.getAuthSessionTicket()
	steam_id = Steam.getSteamID()

func _on_get_auth_session_ticket_response(this_auth_ticket: int, result: int) -> void:
	print("Auth session result: %s" % result)
	print("Auth session ticket handle: %s" % this_auth_ticket)

	# Callback from attempting to validate the auth ticket
func _on_validate_auth_ticket_response(auth_id: int, response: Steam.AuthSessionResponse, owner_id: int) -> void:
	print("Ticket Owner: %s" % auth_id)

	# Make the response more verbose, highly unnecessary but good for this example
	var verbose_response: String
	match response:
		Steam.AUTH_SESSION_RESPONSE_OK: verbose_response = "Steam has verified the user is online, the ticket is valid and ticket has not been reused."
		Steam.AUTH_SESSION_RESPONSE_USER_NOT_CONNECTED_TO_STEAM: verbose_response = "The user in question is not connected to Steam."
		Steam.AUTH_SESSION_RESPONSE_NO_LICENSE_OR_EXPIRED: verbose_response = "The user doesn't have a license for this App ID or the ticket has expired."
		Steam.AUTH_SESSION_RESPONSE_VAC_BANNED: verbose_response = "The user is VAC banned for this game."
		Steam.AUTH_SESSION_RESPONSE_LOGGED_IN_ELSEWHERE: verbose_response = "The user account has logged in elsewhere and the session containing the game instance has been disconnected."
		Steam.AUTH_SESSION_RESPONSE_VAC_CHECK_TIMED_OUT: verbose_response = "VAC has been unable to perform anti-cheat checks on this user."
		Steam.AUTH_SESSION_RESPONSE_AUTH_TICKET_CANCELED: verbose_response = "The ticket has been canceled by the issuer."
		Steam.AUTH_SESSION_RESPONSE_AUTH_TICKET_INVALID_ALREADY_USED: verbose_response = "This ticket has already been used, it is not valid."
		Steam.AUTH_SESSION_RESPONSE_AUTH_TICKET_INVALID: verbose_response = "This ticket is not from a user instance currently connected to steam."
		Steam.AUTH_SESSION_RESPONSE_PUBLISHER_ISSUED_BAN: verbose_response = "The user is banned for this game. The ban came via the Web API and not VAC."
	print("Auth response: %s" % verbose_response)
	print("Game owner ID: %s" % owner_id)

func validate_auth_session(ticket: Dictionary, user_steam_id: int) -> void:
	var auth_response: int = Steam.beginAuthSession(ticket.buffer, ticket.size, user_steam_id)

	# Get a verbose response; unnecessary but useful in this example
	var verbose_response: String
	match auth_response:
		Steam.BEGIN_AUTH_SESSION_RESULT_OK: verbose_response = "Ticket is valid for this game and this Steam ID."
		Steam.BEGIN_AUTH_SESSION_RESULT_INVALID_TICKET: verbose_response = "The ticket is invalid."
		Steam.BEGIN_AUTH_SESSION_RESULT_DUPLICATE_REQUEST: verbose_response = "A ticket has already been submitted for this Steam ID."
		Steam.BEGIN_AUTH_SESSION_RESULT_INVALID_VERSION: verbose_response = "Ticket is from an incompatible interface version."
		Steam.BEGIN_AUTH_SESSION_RESULT_GAME_MISMATCH: verbose_response = "Ticket is not for this game."
		Steam.BEGIN_AUTH_SESSION_RESULT_EXPIRED_TICKET: verbose_response = "Ticket has expired."
	print("Auth verifcation response: %s" % verbose_response)

	if auth_response == 0:
		print("Validation successful, adding user to client_auth_tickets")
		client_auth_tickets.append({"id": user_steam_id, "ticket": ticket.id})

	# You can now add the client to the game

func cancel_auth_ticket() -> void:
	Steam.cancelAuthTicket(auth_ticket.id)

func end_client_sessions() -> void:
	for this_client_ticket in client_auth_tickets:
		Steam.endAuthSession(this_client_ticket.id)
	# Then remove this client from the ticket array
		client_auth_tickets.erase(this_client_ticket)
