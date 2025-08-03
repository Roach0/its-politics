class_name SelectionArrow
extends Path2D

@onready var arrow: Polygon2D = $Line2D/Arrow

@export var initial_point: Vector2i = Vector2i(600, 600)

func _ready():
	curve = curve.duplicate()
	curve.add_point(initial_point)
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	curve.add_point(mouse_pos)
	curve.set_point_in(1, Vector2(-100, -5))
	# curve.set_point_out(1, Vector2(600, 50))

func _process(_delta):
	$Line2D.points = []
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()

	# Set tip of arrow to the mouse position
	arrow.global_position = mouse_pos

	var arrow_back_position: Vector2 = get_arrow_vertex_position(3)

	# Calculate the direction from the start point to mouse
	var start_point = curve.get_point_position(0)
	var direction = (arrow_back_position - start_point).normalized()

	# Shorten the line by a small amount (adjust this value as needed)
	var line_shortening = 10.0  # pixels to shorten by
	var shortened_end = arrow_back_position - direction * line_shortening

	# Set the curve end point to the shortened position
	curve.set_point_position(1, shortened_end)

	for point in curve.get_baked_points():
		$Line2D.add_point(point)

func get_arrow_vertex_position(vertex_index: int) -> Vector2:
	var xform := arrow.get_global_transform_with_canvas()
	var arrow_back_position := xform * arrow.polygon[vertex_index]
	var offset := arrow.offset
	return arrow_back_position - offset
