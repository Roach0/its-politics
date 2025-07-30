class_name GovernmentType
extends Resource

var name: String
var positions: Array[Position] = []
var flow_connections = {}  # Dictionary of position_id: [connected_position_ids]

func _init(gov_name: String):
	name = gov_name

func get_flow_destinations(position_id: int) -> Array:
	return flow_connections.get(position_id, [])
