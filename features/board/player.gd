class_name Player
extends Resource

var id: int
var name: String

var score: int
var points: int

func _init(this_id: int, this_name: String):
	self.id = this_id
	self.name = this_name
	self.score = 0
	self.points = 0
