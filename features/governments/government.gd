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
		offices[i].add_child(official)

	await get_tree().create_timer(1.0).timeout

	var winner = election(2)
	_on_election_finished(2, winner)

func get_competitors_for_office(office_id: int) -> Array[Official]:
	var competitors: Array[Official] = []
	var allowed_promotions = government_type.allowed_promotions[office_id]
	print("allowed_promotions: %s" % allowed_promotions)
	for competitor_position in allowed_promotions:
		print("competitor_position: %s" % competitor_position)
		if offices[competitor_position].is_occupied():
			print("competitor_position is occupied, adding official to competitors")
			competitors.append(offices[competitor_position].official)
	return competitors

func election(office_id: int) -> Official:
	var competitors = get_competitors_for_office(office_id)
	print("%s competitors for office %s: %s" % [competitors.size(), office_id, competitors])
	if competitors.size() == 0:
		return
	if competitors.size() == 1:
		return competitors[0]
	var winner = competitors[randi() % competitors.size()]
	return winner

func _on_election_finished(office_id: int, winner: Official):
	if winner == null:
		return
	offices[office_id].set_official(winner)
