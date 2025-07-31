class_name GovernmentType
extends Resource

var name: String
var offices: Array[Office] = []
var allowed_promotions: Array[int] = []

func _init(gov_name: String):
	name = gov_name
