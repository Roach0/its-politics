extends Node2D

@export var card: Card = null

func _init(initial_card: Card = null) -> void:
	self.card = initial_card

func _ready() -> void:
	if card == null:
		print("Card is null")
		return

	$Panel/Layout/Name.text = card.name
	$Panel/Layout/Description.text = card.description
	$Panel/Layout/Cost.text = str(card.cost)
	# $Panel/Portrait.texture = card.portrait
