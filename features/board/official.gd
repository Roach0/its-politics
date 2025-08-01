# scripts/classes/official.gd
class_name Official
extends Node2D

signal death_time_updated(official: Official, new_value: int)
signal asset_added(official: Official, asset: Asset)
signal asset_removed(official: Official, asset: Asset)
signal official_died(official: Official)

var official_id: String
var death_time: int # Time To Die
var assets: Array[Asset] = []

# func _init(id: String, initial_ttp: int):
# 	official_id = id
# 	death_time = initial_ttp

func add_asset(asset: Asset):
	assets.append(asset)
	asset_added.emit(self, asset)

func remove_asset(index: int):
	var asset = assets[index]
	assets.remove_at(index)
	asset_removed.emit(self, asset)

func update_death_time(delta: int):
	death_time += delta
	if death_time <= 0:
		die()
	death_time_updated.emit(self, death_time)

func die():
	official_died.emit(self)
