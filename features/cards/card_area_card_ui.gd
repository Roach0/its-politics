extends Panel

signal card_area_card_selected(card_area_card_ui: Panel, card: Card)
signal card_area_card_unselected(card_area_card_ui: Panel, card: Card)
signal card_area_card_hovered(card_area_card_ui: Panel, card: Card)
signal card_area_card_hovered_exited(card_area_card_ui: Panel, card: Card)

@export var card: Card = null

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_area_card_selected.emit(self, card)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		card_area_card_unselected.emit(self, card)

func _on_mouse_entered() -> void:
	card_area_card_hovered.emit(self, card)

func _on_mouse_exited() -> void:
	card_area_card_hovered_exited.emit(self, card)
