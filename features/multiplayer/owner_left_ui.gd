extends CanvasLayer

func _ready() -> void:
	SteamNetworkManager.owner_left_ui = self

func _on_okay_button_pressed() -> void:
	hide()