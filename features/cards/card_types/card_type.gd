class_name CardType
extends Resource

enum Target {
	OFFICIAL,
	OFFICE,
	GOVERNMENT,
}

@export var name: String
@export var target: Target

func can_apply_to(target_node: Node) -> bool:
	match target:
		Target.OFFICIAL:
			return target_node is Official
		Target.OFFICE:
			return target_node is Office
		Target.GOVERNMENT:
			return target_node is Government
		_:
			return false
