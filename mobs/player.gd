extends KinematicBody2D

var root_scene = null
var gui = null
var camera = null

#signal move

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 560
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time = 99999 #time since last shot

var timer = null

var _name = "Player"
var id = 0
var hp = 100
var invulnerability = false
var invulnerabilityTime = 1

var score = 0

var dir = "right"

var armed = [null, null, null]
var weapon_selected = null
var activeslot = 0
var weapon_sprite = null
var fire_on = false

func _ready():
	start_functions()

func start_functions():
	add_nodes()
	add_timer()
	get_equipment()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	gui = root_scene.get_node("gui")
	camera =get_node("Camera2D")
	weapon_sprite = get_node("weapon")

#func _process(delta):
	#pass

func _physics_process(delta):
	#sprite.modulate.a8 = 55
	
	### collide
	body_hit()
	
	onair_time += delta
	shoot_time += delta
	### MOVEMENT ###
	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0
	on_floor = onair_time < MIN_ONAIR_TIME
	### CONTROL ###
	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("ui_a"):
		target_speed -=  1
		if !fire_on:
			dir = "left"
	if Input.is_action_pressed("ui_d"):
		if !fire_on:
			dir = "right"
		target_speed +=  1
	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)
	# Jumping
	if on_floor and Input.is_action_just_pressed("ui_space"):
		linear_vel.y = -JUMP_SPEED
	# Reloading
	if weapon_selected != null and weapon_selected.magazine == 0:
		weapon_selected.reloading()
	# Shooting
	if Input.is_action_pressed("left_click"):
		if weapon_selected != null:
			shooting()
	# Swap Weapon
	if Input.is_action_pressed("ui_1"):
		swap_weapon(0)
	if Input.is_action_pressed("ui_2"):
		swap_weapon(1)
	#Blow Up
	if Input.is_action_pressed("ui_accept"):
		map.blow_up()
	
	#Animation
	var aim = get_global_mouse_position()
	if dir == "right":
		weapon_sprite.rotation = 0
		look_at(aim)
		#var myAngle = rotation*57.3
		if rotation > 1.6:
			rotation = 1.6
		elif rotation < -1.6:
			rotation = - 1.6
		weapon_sprite.rotation = rotation
		weapon_sprite.scale.y = 1
		weapon_sprite.scale.x = 1
		if weapon_selected._name == "Pistol":
			weapon_sprite.position.x = 32
		elif weapon_selected._name == "Machinegun":
			weapon_sprite.position.x = 0
		rotation = 0
	elif dir == "left":
		weapon_sprite.rotation = 0
		look_at(aim)
		#var myAngle = rotation*57.3
		if rotation > -1.6 and rotation < 1.6:
			if rotation > -1.6 and rotation < 0:
				rotation = -1.6
			elif rotation > 0 and rotation < 1.6:
				rotation = 1.6
		weapon_sprite.rotation = rotation
		weapon_sprite.scale.y = -1
		weapon_sprite.scale.x = 1
		if weapon_selected._name == "Pistol":
			weapon_sprite.position.x = -32
		elif weapon_selected._name == "Machinegun":
			weapon_sprite.position.x = 0
		rotation = 0
	#Updating
	update_gui()
	#camera_stabilised()

func update_gui():
	if weapon_selected != null:
		gui.get_node("magazine").set_text(str(weapon_selected.magazine))
		gui.get_node("ammo").set_text(str(weapon_selected.ammo))
	gui.get_node("score").set_text(str(score))
	gui.get_node("hp").set_text(str(hp))

func get_equipment():
	var w = map.weapon.shooting[0].duplicate()
	w.position = global_position
	self.add_child(w)
	var w_sprite = get_node("weapon")
	w_sprite.visible = true
	w_sprite.set_texture(w.sprite)
	#w_sprite.position = Vector2(32, 10)
	weapon_selected = w
	armed.remove(0)
	armed.insert(0, w)

func set_weapon(type):
	weapon_selected = type.duplicate()
	self.add_child(weapon_selected)
	var w_sprite = get_node("weapon")
	w_sprite.visible = true
	w_sprite.set_texture(type.sprite)
	armed.remove(1)
	armed.insert(1, weapon_selected)

func swap_weapon(slot):
	if armed[slot] != null:
		var w_sprite = get_node("weapon")
		w_sprite.set_texture(armed[slot].sprite)
		weapon_selected = armed[slot]

func shooting():
	if weapon_selected._name == "Pistol":
		weapon_selected.shoot(weapon_selected)
		weapon_sprite.get_node("Position2D").position = Vector2(45, -3)
	elif weapon_selected._name == "Machinegun":
		weapon_selected.shoot(weapon_selected)
		weapon_sprite.get_node("Position2D").position = Vector2(110, 8)

func on_hit():
	invulnerability = true
	timer.set_wait_time(invulnerabilityTime)
	timer.start()

func body_hit():
	var cnt = get_slide_count()-1
	if cnt >= 0:
		var col = get_slide_collision(cnt)
		if col.collider != null:
			if col.collider.is_in_group("laser"): 
				col.collider.destroy()
				if !invulnerability:
					hp -= 15
					on_hit()

func camera_stabilised():
	camera.global_transform = global_transform

func add_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.set_autostart(false)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)

func _on_Timer_timeout():
	if invulnerability:
		invulnerability = false