class_name Office
extends Node2D

var type: OfficeType
var official: Official = null

func is_occupied() -> bool:
	return official != null

func is_empty() -> bool:
	return official == null

func set_official(new_official: Official, animate: bool = true):
	official = new_official

	if official != null and animate:
		create_tween().tween_property(official, "global_position", global_position, 0.25)

	add_child(official)
