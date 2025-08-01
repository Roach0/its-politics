class_name Government
extends Node2D

@export var government_type: GovernmentType

var offices: Array[Office] = []

func _ready():
	for child in get_children():
		offices.append(child)

	for i in range(offices.size()):
		if i == 2:
			continue

		var official = preload("res://features/board/official.tscn").instantiate()
		offices[i].set_official(official)

	await get_tree().create_timer(1.0).timeout

	var winner = election(2)
	_on_election_finished(2, winner)

func get_competitors_for_office(office_id: int) -> Array[Official]:
	var competitors: Array[Official] = []
	var allowed_promotions = government_type.allowed_promotions[office_id]
	for competitor_position in allowed_promotions:
		if offices[competitor_position].is_occupied():
			competitors.append(offices[competitor_position].official)
	return competitors

func election(office_id: int) -> Official:
	var competitors = get_competitors_for_office(office_id)
	if competitors.size() == 0:
		return
	if competitors.size() == 1:
		return competitors[0]
	var winner = competitors[randi() % competitors.size()]
	return winner

func _on_election_finished(office_id: int, winner: Official):
	offices[office_id].set_official(winner)
