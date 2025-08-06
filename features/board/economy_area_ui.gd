extends ColorRect

@onready var health_bar = $VBoxContainer/HealthBar
@onready var food_bar = $VBoxContainer/FoodBar
@onready var wealth_bar = $VBoxContainer/WealthBar

func _ready():
	health_bar.max_value = 100
	food_bar.max_value = 100
	wealth_bar.max_value = 100
	
	health_bar.value = 50
	food_bar.value = 50
	wealth_bar.value = 50

var tween = get_tree().create_tween()

func bar_change(bar:ProgressBar, new_value:float):
	tween.tween_property(bar, "value", new_value, 0.5)

func _on_health_change(value:):
	bar_change(health_bar,0.5) #change to card value pass in, liquidation or other triggers.
	
func _on_food_change():
	bar_change(food_bar,5.5)

func _on_wealth_change():
	bar_change(wealth_bar,5.5)
	
func liquidation(card:Card):
	bar_change(health_bar, card.health_cost)
	bar_change(food_bar, card.food_cost)
	bar_change(wealth_bar, card.wealth_cost)
