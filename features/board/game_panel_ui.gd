class_name GamePanelUi
extends ColorRect

var player_ui_by_id: Dictionary = {}

@onready var player_container: VBoxContainer = $MarginContainer/VBoxContainer/PlayersContainer
@onready var round_label: RichTextLabel = $MarginContainer/VBoxContainer/RoundContainer/MarginContainer/Round
@onready var end_turn_button: Button = $MarginContainer/VBoxContainer/EndTurnContainer/EndTurnButton

func _ready():
	TurnManager.round_started.connect(_on_round_started)
	TurnManager.turn_started.connect(_on_turn_started)

func set_players(players: Array[Player]):
	for child in player_container.get_children():
		child.queue_free()

	for player in players:
		var player_ui = preload("res://features/board/player_ui.tscn").instantiate()
		player_container.add_child(player_ui)
		player_ui.set_player(player)
		player_ui_by_id[player.id] = player_ui

func _on_round_started(player: Player, round_number: int):
	_set_active_player(player)

	round_label.text = "Round %s" % round_number

func _on_turn_started(player: Player):
	_set_active_player(player)

	round_label.text = "Turn %s" % TurnManager.turn_number

func _set_active_player(player: Player):
	if SteamAuthManager.steam_id == player.id:
		end_turn_button.disabled = false
	else:
		end_turn_button.disabled = true

	for player_ui in player_ui_by_id.values():
		player_ui.set_active(player_ui.player == player)


func _on_end_turn_pressed() -> void:
	TurnManager.end_turn()
