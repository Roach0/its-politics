extends Control

@onready var lobby_list_ui: Control = $Margin/LobbyListUi
@onready var lobby_ui: Control = $Margin/LobbyUi

func _ready() -> void:
	SteamNetworkManager.lobby_entered.connect(_on_enter_lobby)
	SteamNetworkManager.owner_left.connect(_on_owner_left)
	lobby_ui.leave_lobby.connect(_on_leave_lobby)

func _on_enter_lobby() -> void:
	print("Lobby joined %s" % SteamNetworkManager.lobby_id)

	# Switch UIs by removing one and adding the other
	lobby_list_ui.hide()
	lobby_ui.show()

	lobby_ui.initialize(SteamNetworkManager.lobby_name)

func _on_leave_lobby() -> void:
	SteamNetworkManager.leave_lobby()

	# Switch UIs by removing one and adding the other
	lobby_list_ui.show()
	lobby_ui.hide()


func _on_owner_left() -> void:
	if lobby_ui.visible:
		lobby_ui.hide()
		lobby_list_ui.show()
	$OwnerLeftUi.show()