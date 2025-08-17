class_name Office
extends Node2D

@onready var official_position: Node2D = $OfficialPosition

var type: OfficeType
var official: Official = null

func is_occupied() -> bool:
	return official != null

func is_empty() -> bool:
	return official == null

func set_official(new_official: Official, animate: bool = true):
	official = new_official

	if animate:
		create_tween().tween_property(official, "global_position", official_position.global_position, 0.25)
	else:
		official.global_position = official_position.global_position

	add_child(official)
