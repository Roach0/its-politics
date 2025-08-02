extends VBoxContainer

@onready var name_label: RichTextLabel = $NameContainer/Margin/Name
@onready var score_label: RichTextLabel = $ScoreContainer/Margin/Score
@onready var points_label: RichTextLabel = $PointsContainer/Margin/Points

var player: Player

func _ready():
	pass

func set_player(this_player: Player):
	player = this_player
	name_label.text = player.steam_name
	score_label.text = str(player.score)
	points_label.text = str(player.points)
