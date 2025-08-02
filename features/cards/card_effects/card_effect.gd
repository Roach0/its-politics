class_name CardEffect
extends Resource

enum Target {
    OFFICIAL,
    OFFICE,
}

@export var target: Target

# Virtual method that subclasses must implement
func apply_effect(_target_node: Node) -> void:
    push_error("apply_effect must be implemented by subclass")