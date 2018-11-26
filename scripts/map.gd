extends Node

var width = 960*2
var height = 640

var root_scene = null
var player = null

var finished = false

var tileset = preload("res://tileset/places.tscn")
var playerScene = preload("res://mobs/player.tscn")
var gamebackground = preload("res://tileset/gamebackground.tscn")
var spawnScene = preload("res://parts/spawn.tscn")
var shooting_weapon = preload("res://parts/shooting_weapon.tscn")
var enemysScene = preload("res://mobs/Enemys.tscn")
var blockScene = preload("res://parts/block.tscn")
var checkLineScene = preload("res://parts/check_line.tscn")
var lineScene = preload("res://parts/line.tscn")

var spawns = []
var tiles = []
var enemys = []
var weapon = { shooting = [], melee = [], throw = [] }
var blocks = []

var living_enemy = 0
var cubeList = []
var connectLines = []
var line = 0
var chekMas = []

var lvlStep = 0

var _offset = 64

func _ready():
	pass

func _physics_process(delta):
	chekMas[0].visible = false
	chekMas[0].visible = true

func start_functions():
	add_nodes()
	add_classes()
	map_create()
	#fillMas()
	create_player()
	create_mob()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

func create_player():
	var p = playerScene.instance()
	root_scene.add_child(p)
	player = root_scene.get_node("player")
	player.position = root_scene.get_node("player_spawn").position

func add_classes():
	var t = tileset.instance()
	for i in t.get_children().size():
		if t.get_child(i).is_in_group("place"):
			tiles.append(t.get_child(i))
	var s = spawnScene.instance()
	for i in s.get_children().size():
		if s.get_child(i).is_in_group("spawn"):
			spawns.append(s.get_child(i))
	var sw = shooting_weapon.instance()
	for i in sw.get_children().size():
		if sw.get_child(i).is_in_group("weapon"):
			weapon.shooting.append(sw.get_child(i))
	var e = enemysScene.instance()
	for i in e.get_children().size():
		if e.get_child(i).is_in_group("enemy"):
			enemys.append(e.get_child(i))
	var b = blockScene.instance()
	for i in b.get_children().size():
		if b.get_child(i).group == "block":
			blocks.append(b.get_child(i))
			

func map_create():
	var step = { x = 0, y = 0 }
	### background ###

	### BOX ###
	var place = { p1 = 7, p2 = 9 }
	for i in place.p1:
		var place1 = tiles[0].duplicate()
		var place2 = tiles[2].duplicate()
		if i == 0:
			place1.position = Vector2(960+960-32, 320)
			place1.set_global_rotation_degrees(90)
			root_scene.add_child(place1)
		elif i == 1:
			place1.position = Vector2(32, 320)
			place1.set_global_rotation_degrees(90)
			root_scene.add_child(place1)
		elif i == 2:
			place1.position = Vector2(960+480, 640-32)
			root_scene.add_child(place1)
			pass
		elif i == 3:
			place1.position = Vector2(480, 640-32)
			root_scene.add_child(place1)
			chekMas.append(place1)
		elif i == 4:
			place1.position = Vector2(240, -96)
			place1.scale.x = 0.5
			root_scene.add_child(place1)
			chekMas.append(place1)
		elif i == 5:
			place1.position = Vector2(960+480+240, -96)
			place1.scale.x = 0.5
			root_scene.add_child(place1)
			chekMas.append(place1)
		elif i == 6:
			place2.position = Vector2(960, -96)
			root_scene.add_child(place2)
			chekMas.append(place2)
	### platforms ###
	for i in place.p2:
		var place2 = tiles[1].duplicate()
		if i < 4:
			step.y = 160
			place2.position = Vector2(128+step.x, 640-32-step.y)
			root_scene.add_child(place2)
			step.x += 512
			if i == 1:
				step.x += 128
			if i == 3:
				step.x = 0
				step.y += 160
		if i >= 4:
			place2.position = Vector2(384+step.x, 640-32-step.y)
			root_scene.add_child(place2)
			step.x += 512
			if i == 4:
				step.x += 64
			if i == 5:
				step.x += 64
	for i in range(2):
		var place2 = tiles[1].duplicate()
		if i == 0:
			place2.position = Vector2(768-96, 128+32)
			root_scene.add_child(place2)
		if i == 1:
			place2.position = Vector2(768-96+480, 128+32)
			root_scene.add_child(place2)
		
	### spawns ###
	var s = spawns[0].duplicate()
	s.position = Vector2(96, 548)
	root_scene.add_child(s)
	
	var w = spawns[2].duplicate()
	w.position = Vector2(384, 548)
	root_scene.add_child(w)
	
	weapon_create(1, w.position + Vector2(10, 0), root_scene)
	
	var b = spawns[3].duplicate()
	b.position = Vector2(896+64, -96-64)
	root_scene.add_child(b)
	
	var e = spawns[1].duplicate()
	e.position = Vector2(1824, 548)
	root_scene.add_child(e)
	
	var e2 = spawns[1].duplicate()
	e2.position = Vector2(960, 240)
	root_scene.add_child(e2)
	### Check Line Zone ###
	var c = checkLineScene.instance()
	c.position = Vector2(960, 640-90)
	root_scene.add_child(c)
	
	finished = true

func create_mob():
	var en1 = enemys[2].duplicate()
	en1.position = Vector2(640, 548)
	root_scene.add_child(en1)
	
	var en2 = enemys[3].duplicate()
	en2.position = Vector2(640, 300)
	root_scene.add_child(en2)

func weapon_create(type, pos, scene):
	var w = weapon.shooting[type].duplicate()
	w.position = pos
	scene.add_child(w)

func blow_up():
	pass

func fillMas():
	var mas = []
	for i in range(8):
		connectLines.append(mas)

func open_gate():
	root_scene.get_node("gate/area_gate/Collision3").set_disabled(true)
	root_scene.get_node("gate/sprite1").visible = false
	root_scene.get_node("gate/sprite2").visible = true





