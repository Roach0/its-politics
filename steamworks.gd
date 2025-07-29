extends Node

func _ready() -> void:
	initialize_steam()

# Initializes steam lol
# added a txt file with temporary app ID also, for testing
# logging has also been enabled in the editor
func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s " % initialize_response)
	# shuts down game if steam does not initialize
	if initialize_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()
