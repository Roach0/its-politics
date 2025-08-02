# scripts/classes/official.gd
class_name Official
extends Node2D

signal death_time_updated(official: Official, new_value: int)
signal asset_added(official: Official, asset: Asset)
signal asset_removed(official: Official, asset: Asset)
signal official_died(official: Official)

var death_time: int
var assets: Array[Asset] = []

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
