extends Node2D

@export var card: Card = null

@onready var name_label: Label = $CardSprite/Name
@onready var description_label: Label = $CardSprite/Description
@onready var food_cost_label: Label = $CardSprite/FoodCost
@onready var wealth_cost_label: Label = $CardSprite/WealthCost
@onready var health_cost_label: Label = $CardSprite/HealthCost

func _init(initial_card: Card = null) -> void:
	self.card = initial_card

func _ready() -> void:
	if card == null:
		print("Card is null")
		return

	name_label.text = card.name
	description_label.text = card.description
	food_cost_label.text = str(card.food_cost)
	wealth_cost_label.text = str(card.wealth_cost)
	health_cost_label.text = str(card.health_cost)
	# $Panel/Portrait.texture = card.portrait
