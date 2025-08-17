extends ColorRect

@onready var government_name: Label = $Margin/GovPanel/Margin/GovName
@onready var gov_pos: Node2D = $Margin/GovPanel/GovPosition

func _ready() -> void:
	var government_type = preload("res://features/governments/government_types/autocrat.tres")
	load_government(government_type)

func load_government(government_type: GovernmentType) -> void:
	government_name.text = government_type.name

	for child in gov_pos.get_children():
		child.queue_free()

	var government = Government.new(government_type)
	government.government_type_changed.connect(_on_government_type_changed)
	gov_pos.add_child(government)

func _on_government_type_changed(new_government_type: GovernmentType) -> void:
	government_name.text = new_government_type.name
