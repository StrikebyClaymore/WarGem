extends Area2D

var root_scene = null
var player = null
var timer = null

var coldown = false
var coldownTime = 5

var limit_enemys = 5

func _ready():
	start_functions()

func start_functions():
	add_nodes()
	randomize(true)
	
func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	player = root_scene.get_node("player")
	timer = get_node("Timer")

func _physics_process(delta):
	if map.lvlStep == 0:
		spwan_enemys()

func spwan_enemys():
	if map.living_enemy < limit_enemys  and !coldown:
		var s_rand = rand_range(1, 10)
		var type = null
		if s_rand > 0 and s_rand <= 5:
			type = 0
		elif s_rand > 5 and s_rand <= 8:
			type = 1
		elif s_rand > 8 and s_rand <= 10:
			type = 2
		var e = map.enemys[type].duplicate()
		e.position = global_position
		root_scene.add_child(e)
		map.living_enemy += 1
		coldown = true
		timer.set_wait_time(coldownTime)
		timer.start()

func _on_Timer_timeout():
	coldown = false
