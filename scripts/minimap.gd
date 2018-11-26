extends Node2D

var root_scene = null
var player = null
var mobsMas = []
var miniMas = []
var id = 1

var width = 960
var heiht = 640
var screen_size = Vector2(960, 640)

var zero = Vector2(-48, 32)

var cameraActive = false
var last_player_pos = null
var player_new_pos = null

var rect = preload("res://parts/rect.tscn")

# 15 - 960
# 10 - 640

func _ready():
	pass

func _physics_process(delta):
	#find_life()
	#if cameraActive:
		#update_pos()
		#update_camera()
	pass

func start_functions():
	add_nodes()
	#find_life()
	#drawing()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	player = root_scene.get_node("player")

func find_life():
	var mas = []
	for i in root_scene.get_children().size():
		if mobsMas.size() == 0:
			if root_scene.get_child(i).is_in_group("player"):
				mobsMas.append(root_scene.get_child(i))
				root_scene.get_child(i).id = 0
				drawing(root_scene.get_child(i))
		else:
			for j in mobsMas.size():
				if root_scene.get_child(i) != mobsMas[j] and root_scene.get_child(i).is_in_group("enemy") and !root_scene.get_child(i).is_in_group("draw"):
					mobsMas.append(root_scene.get_child(i))
					root_scene.get_child(i).id = id
					drawing(root_scene.get_child(i))
					id += 1

func drawing(obj):
	if obj.is_in_group("player") and !obj.is_in_group("draw"):
		var r = rect.instance()
		r.get_node("ColorRect").set_frame_color("37b72c")
		r.scale = Vector2(0.1, 0.1)
		r.position = Vector2(828-128*1.4, 89+128)
		r.position += Vector2(6.4*2, -6.4*3)
		print(global_position)
		r.id = obj.id
		r.add_to_group("draw")
		r.add_to_group("player")
		obj.add_to_group("draw")
		root_scene.add_child(r)
		miniMas.append(r)
		print(miniMas[0])
		set_camera()
	elif obj.is_in_group("enemy") and !obj.is_in_group("draw"):
		var r = rect.instance()
		r.get_node("ColorRect").set_frame_color("981d1d")
		r.scale = Vector2(0.1/3, 0.1/2)
		r.position = obj.position*0.1/2 - Vector2(32, 32)
		r.id = obj.id
		r.add_to_group("draw")
		obj.add_to_group("draw")
		add_child(r)
		miniMas.append(r)

func set_camera():
	last_player_pos = miniMas[0].position
	cameraActive = true

func update_camera():
	var hero = miniMas[0]
	last_player_pos = player.position*0.1/2 - Vector2(32, 0)
	var player_offset = last_player_pos + player.position*0.1/2 + Vector2(1, 0)

	#print(player_offset)

func update_pos():
	for i in miniMas.size():
		for j in mobsMas.size():
			var wr1 = weakref(miniMas[i])
			var wr2 = weakref(mobsMas[j])
			#print(miniMas[i], " ", mobsMas[j])
			#print(!!wr1.get_ref(), " ", !!wr2.get_ref())
			if !!wr1.get_ref() and !!wr2.get_ref():
				if miniMas[i].id == mobsMas[j].id:
					miniMas[i].position = player.position*0.1 + Vector2(828-128*1.4, 89+128)
						
				














