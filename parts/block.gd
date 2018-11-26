extends KinematicBody2D

var root_scene = null
var block_spawn = null

var _name = ""
var id = 0
var group = "block"
var active = true
var program_move = { x = false, y = false }
var step = { x = 2, y = 2 }
var blocksize = { x = 64, y = 64, area = 64*64 }
var scene_grid = null
var connected = []
var this = { x = 0, y = 0, color = null }
var colors = ["purple", "blue", "orange"] #set Sprites
var sprites = [load("res://images/amethyst_triangle_block.png"), load("res://images/topaz_square_block.png"), load("res://images/sapphire_circle_block.png")]
var test = false

var timer = null

func _ready():
	randomize(true)
	add_nodes()
	start_functions()

func _physics_process(delta):
	### MOVE X ###
	if Input.is_action_pressed("ui_q") and !program_move.x:
		step.x = -2
		program_move.x = true
		timer.start()
	if Input.is_action_pressed("ui_e") and !program_move.x:
		step.x = 2
		program_move.x = true
		timer.start()
	### MOVE Y ###
	if Input.is_action_pressed("mouse_wheel_down") and step.y < 384:
		step.y = 2
	if Input.is_action_pressed("mouse_wheel_up") and step.y > 32:
		step.y = -2
	if Input.is_action_pressed("right_click"):
 		step.y = -4
	else:
		step.y = 4
	### ###
	move()

func start_functions():
	add_nodes()
	set_zIndex()
	set_scales(3, 3, 3.2, 3.2)
	set_maskAndColl()
	_add_group()
	add_to_mapList()
	set_ids()
	add_timer()
	
func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	block_spawn = root_scene.get_node("block_spawn")

func add_to_mapList():
	map.cubeList.append(self)

func set_ids():
	for i in root_scene.get_children().size():
		if root_scene.get_child(i) != null and root_scene.get_child(i).is_in_group("block"):
			id += 1

func set_zIndex():
	z_index = -1

func set_scales(x, y, zx, zy):
	for i in get_children().size():
		if get_child(i).get_name() == "CollisionShape2D":
			get_child(i).scale = Vector2(x, y)
	for i in get_children().size():
		if get_child(i).get_name() == "zone":
			for j in get_child(i).get_children().size():
				if get_child(i).get_child(j).get_name() == "CollisionShape2D":
					get_child(i).get_child(j).scale = Vector2(zx, zy)

func cut_number(num):
	var newNum = ""
	var flag = true
	for i in str(num).length():
		if str(num)[i] == ".":
			flag = false
		if flag:
			newNum += str(num)[i]
	return newNum.to_float()

func set_maskAndColl():
	set_collision_mask(16) 
	set_collision_layer(16)
		#print(get_collision_mask_bit(i))
	#for i in get_children().size():
		#if get_child(i).get_name() == "zone":
			#get_child(i).set_collision_layer_bit(1, false)
			#get_child(i).set_collision_layer_bit(5, true)
			#get_child(i).set_collision_mask_bit(1, false)
			#get_child(i).set_collision_mask_bit(5, true)
			#for j in 10:
				#get_child(i).set_collision_mask(get_collision_mask_bit(j)) 
				#get_child(i).set_collision_layer(get_collision_layer_bit(j))
				#print(get_child(i).get_collision_mask_bit(j))

func _add_group():
	add_to_group("block")

func add_timer():
	timer = Timer.new()
	timer.set_autostart(true)
	timer.set_one_shot(false)
	timer.set_wait_time(0.25)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

func move():
	if active:
		if position.x < 480:
			position.x = 1440
		if position.x > 1440:
			position.x = 480
		if program_move.x:
			global_translate(Vector2(step.x, 0))
		elif program_move.y:
			global_translate(Vector2(0, step.y))
		if is_on_floor():
			active = false

func on_timeout_complete():
	if active:
		if program_move.x:
			step.x = 0
			grid_apply(global_position, 1)
			program_move.x = false
		else:
			program_move.y = true

func _on_zone_body_entered(body):
	if body != self and body.is_in_group("block"):
		connected.append(body)
		var col = rand_range(1, 3)
		this.color = colors[col]
		active = false
		block_spawn.activeBlock = false
	if body.is_in_group("floor"):
		active = false
		block_spawn.activeBlock = false
	if body != self and body.is_in_group("block"):
		connected.append(body)

func alls_grid_apply(mas):
	for i in mas.size():
		mas[i].grid_apply(global_position, 3)

func grid_apply(pos, dirs):
	var mapsize = { x = map.width/blocksize.x, y = map.height/blocksize.y }
	var this = { x = pos.x, y = pos.y}
	if dirs == 1:
		for i in this.x/64:
			this.x -= 64
		if this.x < -32:
			this.x = this.x + 64
		else:
			this.x = this.x
		if active:
			global_position.x -= this.x
	if dirs == 2:
		for i in this.y/64:
			this.y -= 64
		if this.y < -32:
			this.y = this.y + 64
		else:
			this.y = this.y
		if active:
			global_position.y -= this.y +32
	if dirs == 3:
		for i in this.x/64:
			this.x -= 64
		if this.x < -32:
			this.x = this.x + 64
		else:
			this.x = this.x
		if active:
			global_position.x -= this.x
		for i in this.y/64:
			this.y -= 64
		if this.y < -32:
			this.y = this.y + 64
		else:
			this.y = this.y
		if active:
			global_position.y -= round(this.y +30)