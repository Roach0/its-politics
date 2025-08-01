class_name AssetEffects
extends Resource

@export var id: String
@export var group_name: String
@export var effect_function_name: String
@export var description: String

func execute(official : Official=null,office : Office=null):
	if has_method(effect_function_name):
		call(effect_function_name, official, office)
	else:
		push_error("Missing function '%s' in CardEffect" % effect_function_name)
		
func spawn_asset(asset_scene:Resource, parent_nodes:Array[Node], condition:bool):
	if condition :
		for node in parent_nodes:
			var asset = asset_scene.instantiate()
			node.add_child(asset)
