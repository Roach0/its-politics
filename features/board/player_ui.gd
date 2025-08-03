extends Panel

@onready var name_label: Label = $Margin/PlayerContainer/NameContainer/Margin/Name
@onready var score_label: Label = $Margin/PlayerContainer/ScoreContainer/Margin/Score
@onready var points_label: Label = $Margin/PlayerContainer/PointsContainer/Margin/Points

var player: Player

func _ready():
	pass

func set_player(this_player: Player):
	player = this_player
	name_label.text = player.name
	score_label.text = str(player.score)
	points_label.text = str(player.points)

func set_active(is_active: bool):
	var active_player_style_box: StyleBoxFlat = preload("res://assets/ui/active_player_style_box.tres")
	var inactive_player_style_box: StyleBoxFlat = preload("res://assets/ui/inactive_player_style_box.tres")

	if is_active:
		add_theme_stylebox_override("panel", active_player_style_box)
	else:
		add_theme_stylebox_override("panel", inactive_player_style_box)
