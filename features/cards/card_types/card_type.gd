class_name CardType
extends Resource

enum Target {
    OFFICIAL,
    OFFICE,
}

@export var name: String
@export var target: Target

func can_apply_to(target_node: Node) -> bool:
    if target_node.is_in_group("officials"):
        return target == Target.OFFICIAL
    elif target_node.is_in_group("offices"):
        return target == Target.OFFICE
    else:
        return false