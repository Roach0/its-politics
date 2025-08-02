class_name Player
extends Resource

var steam_id: int
var steam_name: String

var score: int
var points: int

func _init(this_steam_id: int, this_steam_name: String):
	self.steam_id = this_steam_id
	self.steam_name = this_steam_name
	self.score = 0
	self.points = 0