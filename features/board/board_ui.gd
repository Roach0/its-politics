extends HBoxContainer

@onready var game_panel_ui: GamePanelUi = $GamePanelUi

func set_players(players: Array[Player]):
	game_panel_ui.set_players(players)
