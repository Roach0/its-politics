class_name Card
extends Resource

@export var name: String
@export var description: String
@export var portrait: Texture2D
@export var type: CardType
@export var effect: CardEffect
@export var cost: int

func apply_effect(target: Node) -> void:
    if type.can_apply_to(target):
        effect.apply_effect(target)
    else:
        print("Invalid target")