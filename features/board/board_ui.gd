extends HBoxContainer

@onready var game_panel_ui: GamePanelUi = $GamePanelUi
var is_dragging_card: bool = false
var selection_arrow: SelectionArrow = null
var hovered_card_ui: Node = null

func set_players(players: Array[Player]):
	game_panel_ui.set_players(players)

func _on_card_area_card_ui_card_area_card_selected(card_area_card_ui:Panel, _card: Card) -> void:
	is_dragging_card = true
	var new_selection_arrow = preload("res://features/cards/selection_arrow.tscn").instantiate()
	selection_arrow = new_selection_arrow
	# get the center of the card area card ui
	var card_area_card_ui_center: Vector2 = card_area_card_ui.get_global_rect().position + card_area_card_ui.get_global_rect().size / 2
	selection_arrow.initial_point = card_area_card_ui_center
	add_child(selection_arrow)

func _on_card_area_card_ui_card_area_card_unselected(_card_area_card_ui:Panel, _card: Card) -> void:
	is_dragging_card = false
	selection_arrow.queue_free()
	selection_arrow = null
	if hovered_card_ui != null:
		hovered_card_ui.queue_free()
		hovered_card_ui = null

func _on_card_area_card_ui_card_area_card_hovered(card_area_card_ui:Panel, card: Card) -> void:
	if is_dragging_card:
		return
	if hovered_card_ui != null:
		hovered_card_ui.queue_free()
	var card_ui = preload("res://features/cards/card_ui.tscn").instantiate()
	card_ui.card = card

	# Get the card sprite to calculate its width
	var card_sprite = card_ui.get_node("CardSprite")
	var card_width = card_sprite.texture.get_width() * card_sprite.scale.x * 0.5
	var card_height = card_sprite.texture.get_height() * card_sprite.scale.y * 0.5
	var horizontal_offset = Vector2(20.0, 0.0)

	# Position the card at the right edge of the card area, accounting for card width
	var card_area_card_ui_right_center: Vector2 = card_area_card_ui.position + Vector2(card_area_card_ui.size.x + card_width, card_area_card_ui.size.y / 2) + horizontal_offset

	# Check if card would be off-screen and adjust position
	var viewport_size = get_viewport().get_visible_rect().size

	var vertical_offset = Vector2(0.0, 10.0)

	# Check if top of card would be off-screen
	if card_area_card_ui_right_center.y - card_height < 0:
		card_area_card_ui_right_center.y = card_height + vertical_offset.y

	# Check if bottom of card would be off-screen
	if card_area_card_ui_right_center.y + card_height > viewport_size.y:
		card_area_card_ui_right_center.y = viewport_size.y - card_height - vertical_offset.y

	card_ui.position = card_area_card_ui_right_center
	hovered_card_ui = card_ui
	add_child(card_ui)

func _on_card_area_card_ui_card_area_card_hovered_exited(_card_area_card_ui:Panel, _card: Card) -> void:
	if is_dragging_card:
		return
	if hovered_card_ui != null:
		hovered_card_ui.queue_free()
		hovered_card_ui = null