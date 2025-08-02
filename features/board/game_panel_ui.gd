class_name GamePanelUi
extends ColorRect

@onready var player_container: VBoxContainer = $MarginContainer/VBoxContainer/PlayersContainer
@onready var round_label: RichTextLabel = $MarginContainer/VBoxContainer/RoundContainer/MarginContainer/Round

func _ready():
    TurnManager.round_started.connect(_on_round_started)

func set_players(players: Array[Player]):
    for child in player_container.get_children():
        child.queue_free()

    for player in players:
        var player_ui = preload("res://features/board/player_ui.tscn").instantiate()
        player_container.add_child(player_ui)
        player_ui.set_player(player)

func _on_round_started(round_number: int):
    round_label.text = "Round %s" % round_number