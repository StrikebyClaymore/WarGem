extends Node

var root_scene = null
var player = null

func _ready():
	map.start_functions()
	start_functions()
	root_scene.get_node("gui/minimap").start_functions()

func start_functions():
	add_nodes()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	player = root_scene.get_node("player")

