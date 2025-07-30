extends Node

signal turn_started(player_id: int)
signal turn_ended(player_id: int)
signal round_started(round_number: int)
signal round_ended(round_number: int)

var current_player_id: int = -1
var players: Array = []
var round_number: int = 0
var first_player_index: int = 0

func start_game(player_ids: Array):
	players = player_ids
	round_number = 1
	first_player_index = 0
	start_round()

func start_round():
	round_started.emit(round_number)
	current_player_id = players[first_player_index]
	start_turn()

func start_turn():
	turn_started.emit(current_player_id)

@rpc("any_peer", "reliable")
func end_turn():
	if multiplayer.get_remote_sender_id() != current_player_id:
		return
		
	turn_ended.emit(current_player_id)
	
	# Find next player
	var current_index = players.find(current_player_id)
	var next_index = (current_index + 1) % players.size()
	
	# If we're back to the first player, end the round
	if next_index == first_player_index:
		end_round()
	else:
		current_player_id = players[next_index]
		start_turn()

func end_round():
	round_ended.emit(round_number)
	first_player_index = (first_player_index + 1) % players.size()
	round_number += 1
	start_round()
