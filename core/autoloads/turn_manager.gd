extends Node

signal turn_started(player: Player)
signal turn_ended(player: Player)
signal round_started(player: Player, round_number: int)
signal round_ended(round_number: int)

var current_player: Player = null
var players: Array[Player] = []
var round_number: int = 0
var turn_number: int = 0
var first_player_index: int = 0

func start_game(this_players: Array[Player]):
	players = this_players
	round_number = 1
	first_player_index = 0
	start_round()

func start_round():
	round_started.emit(players[first_player_index], round_number)
	current_player = players[first_player_index]
	start_turn()

func start_turn():
	turn_number += 1
	current_player = players[(first_player_index + turn_number) % players.size()]
	turn_started.emit(current_player)

func end_turn():
	if SteamAuthManager.steam_id != current_player.steam_id:
		return

	turn_ended.emit(current_player)

	SteamNetworkManager.send_message({"message": "end_turn"})
	_process_turn_end()

func _process_turn_end():
	# Find next player
	var current_index = players.find(current_player)
	var next_index = (current_index + 1) % players.size()

	# If we're back to the first player, end the round
	if next_index == first_player_index:
		end_round()
	else:
		current_player = players[next_index]
		start_turn()

func end_round():
	round_ended.emit(round_number)
	first_player_index = (first_player_index + 1) % players.size()
	round_number += 1
	start_round()
