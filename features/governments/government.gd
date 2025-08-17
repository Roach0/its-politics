class_name Government
extends Node2D

signal government_type_changed(new_government_type: GovernmentType)

@export var government_type: GovernmentType

var offices: Array[Office] = []

func _init(this_government_type: GovernmentType):
	government_type = this_government_type

func _ready():
	for child in get_children():
		child.queue_free()

	for gov_pos in government_type.positions:
		var office_ui = preload("res://features/offices/office_ui.tscn").instantiate()
		office_ui.position = gov_pos
		offices.append(office_ui)
		add_child(office_ui)

	for i in range(offices.size()):
		if i == 2 or i == 3:
			continue

		var official = preload("res://features/board/official.tscn").instantiate()
		offices[i].add_child(official)

	await get_tree().create_timer(1.0).timeout

	change_government_type(preload("res://features/governments/government_types/succession.tres"))

func get_competitors_for_office(office_id: int) -> Array[Official]:
	var competitors: Array[Official] = []
	if not government_type.allowed_promotions.has(office_id):
		return competitors
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

func change_government_type(new_government_type: GovernmentType):
	government_type = new_government_type

	for i in range(get_child_count()):
		var child = get_child(i)
		create_tween().tween_property(child, "position", new_government_type.positions[i], 0.25)

	government_type_changed.emit(new_government_type)
	await get_tree().create_timer(0.25).timeout
