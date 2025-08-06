extends ColorRect

enum TokenState {EMPTY, FULL, USED}

@onready var health_bar:ProgressBar = $VBoxContainer/HealthBar
@onready var food_bar:ProgressBar = $VBoxContainer/FoodBar
@onready var wealth_bar:ProgressBar = $VBoxContainer/WealthBar
@onready var token_states:Array = [TokenState.EMPTY,TokenState.EMPTY,TokenState.EMPTY] 
@onready var tokens:Array = get_node("$MarginContainer/VBoxContainer/MarginContainer/TokenDisplay").get_children()

var empty_color: Color = Color(0.3, 0.3, 0.3)   # Dark gray
var full_color: Color = Color(0, 1, 0)
var used_color: Color = Color(1, 0.5, 0)      # Orange

func _ready():
	health_bar.max_value = 100
	food_bar.max_value = 100
	wealth_bar.max_value = 100
	
	health_bar.value = 50
	food_bar.value = 50
	wealth_bar.value = 50
	
	for i in range(tokens.size()):
		update_token_appearance(i)
	

var tween = get_tree().create_tween()

func bar_change(bar:ProgressBar, new_value:float):
	tween.tween_property(bar, "value", new_value, 0.5)

func _on_health_change(value:int):
	bar_change(health_bar,value) #change to card value pass in, liquidation or other triggers.
	
func _on_food_change(value:int):
	bar_change(food_bar,value)

func _on_wealth_change(value:int):
	bar_change(wealth_bar,value)
	
func _on_liquidation(card:Card):
	bar_change(health_bar, card.health_cost)
	bar_change(food_bar, card.food_cost)
	bar_change(wealth_bar, card.wealth_cost)

func set_token_state(token_index: int, state: int):
	if token_index < 0 or token_index >= tokens.size():
		push_error("Invalid slot index: " + str(token_index))
		return
	token_states[token_index] = state
	update_token_appearance(token_index)

func update_token_appearance(token_index: int):
	var color_rect: ColorRect = tokens[token_index]
	
	match token_states[token_index]:
		TokenState.EMPTY:
			color_rect.color = empty_color
		TokenState.FULL:
			color_rect.color = full_color
		TokenState.USED:
			color_rect.color = used_color
