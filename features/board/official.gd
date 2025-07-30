# scripts/classes/official.gd
class_name Official
extends Node2D

signal ttp_updated(new_value: int)
signal asset_added(asset: Asset)
signal asset_removed(asset: Asset)
signal official_died()

var official_id: String
var ttp: int  # Time To Play
var assets: Array[Asset] = []
var position_id: int = -1

func _init(id: String, initial_ttp: int):
	official_id = id
	ttp = initial_ttp

func add_asset(asset: Asset) -> bool:
	assets.append(asset)
	asset_added.emit(asset)
	return true

func remove_asset(asset: Asset) -> bool:
	var idx = assets.find(asset)
	if idx != -1:
		assets.remove_at(idx)
		asset_removed.emit(asset)
		return true
	return false

func update_ttp(delta: int):
	ttp += delta
	if ttp <= 0:
		die()
	ttp_updated.emit(ttp)

func die():
	official_died.emit()
	queue_free()
