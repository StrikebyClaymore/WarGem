extends RigidBody2D

var root_scene = null
var player = null
var block_spawn = null
var minimap = null
var timer = null

#var mobs = { triangle = { image = load("res://images/triangleMob2.png") }, square = { image = load("res://images/squareMob2.png") }, hexagon = { image = load("res://images/hexagonMob2.png") } }
var mob_type 

var id = 0
var _name = "Boss1"
var block_id = 0
var status = "passive"

var life = true
var hp = 1800
var maxSpeed = 0

var hit = false
var hitColdown = 0.1

var attack = false
var attackColdown = 1

var target = null

#var explosive = { triangle = preload("res://parts/explosive0.tscn"), square = preload("res://parts/explosive1.tscn"), hexagon = preload("res://parts/explosive2.tscn") }

func _ready():
	start_functions()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	player = root_scene.get_node("player")
	minimap = root_scene.get_node("gui/minimap")
	block_spawn = root_scene.get_node("block_spawn")

func start_functions():
	add_nodes()
	_add_timer()

func _add_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.set_autostart(false)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)