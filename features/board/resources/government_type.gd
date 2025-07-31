class_name GovernmentType
extends Resource

var name: String
var positions: Array[Position] = []
var allowed_promotions: Array[int] = []

func _init(gov_name: String):
	name = gov_name
