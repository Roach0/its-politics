class_name Position
extends Node2D

signal position_vacated(position_id: int)
signal position_filled(position_id: int, official: Official)
signal government_changed(new_type: String)

var current_government: GovernmentType
var positions = {}  # Dictionary of position_id: Position
var position_nodes = {}  # Dictionary of position_id: PositionNode (visual representation)

func change_government(new_gov_type: String):
	# Save current officials
	var current_officials = {}
	for pos_id in positions:
		if positions[pos_id].has_official():
			current_officials[pos_id] = positions[pos_id].get_official()
	
	# Update board layout
	current_government = load_government_type(new_gov_type)
	setup_positions()
	
	# Handle official transitions/deaths based on new government rules
	handle_government_transition(current_officials)

func handle_flow_mechanics(vacated_position_id: int):
	var flow_positions = current_government.get_flow_destinations(vacated_position_id)
	for pos_id in flow_positions:
		if positions[pos_id].has_official():
			var official = positions[pos_id].remove_official()
			positions[vacated_position_id].place_official(official)
			# This might trigger more flows, handle recursively
