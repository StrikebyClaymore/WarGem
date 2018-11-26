extends "res://parts/block.gd"

func _ready():
	initing()
	grid_apply(global_position, 3)

func initing():
	get_node("zone").connect("body_entered", self, "_on_zone_body_entered")
	_name = "Triangle"