extends RigidBody2D

var root_scene = null
var player = null
var firetimer = null

var bullet = preload("res://parts/bullet.tscn")

var id
var _name = null
var sprite = null

var shoot_impulse = 1000
var damage = 0
var ammo = 0
var magazineSize = 0
var magazine = 0
var fireColdown = 1
var reloadColdown = 1
var coldown = false

func _ready():
	start_functions()

func add_scene_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	player = root_scene.get_node("player")
	#firetimer = get_node("fireTimer")

func start_functions():
	add_scene_nodes()
	_add_timer()

func _add_timer():
	firetimer = Timer.new()
	firetimer.set_one_shot(true)
	firetimer.set_wait_time(fireColdown)
	firetimer.set_autostart(false)
	firetimer.connect("timeout", self, "on_timeout_complete")
	add_child(firetimer)

func shoot(type):
	player.fire_on = true
	var aim = get_global_mouse_position()
	var bul = bullet.instance()
	var imp = (get_global_mouse_position() - player.position).normalized()
	if player.dir == "right":
		if imp.x < 0 and imp.y < 0:
			#imp.x = 0
			player.dir = "left"
			coldown = true
			firetimer.start()
		elif imp.x < 0 and imp.y > 0:
			#imp.x = 0
			player.dir = "left"
			coldown = true
			firetimer.start()
	elif player.dir == "left":
		if imp.x > 0 and imp.y < 0:
			#imp.x = 0
			player.dir = "right"
			coldown = true
			firetimer.start()
		elif imp.x > 0 and imp.y > 0:
			#imp.x = 0
			player.dir = "right"
			coldown = true
			firetimer.start()
	if magazine != 0 and !coldown:
		coldown = true
		bul.position = player.weapon_sprite.get_node("Position2D").global_position
		root_scene.add_child(bul)
		bul.rotation = imp.angle()
		bul.damage = type.damage
		bul.apply_impulse(Vector2(), imp*shoot_impulse)
		magazine -= 1
		firetimer.set_wait_time(fireColdown)
		firetimer.start()
		if magazine == 0:
			firetimer.set_wait_time(reloadColdown)
			firetimer.start()
		player.fire_on = false

func reloading():
	if !_name == "Pistol":
		if ammo > 0 and ammo >= magazineSize and !coldown:
			magazine += magazineSize
			ammo -= magazineSize
		elif ammo > 0 and ammo < magazineSize and !coldown:
			magazine += ammo
			ammo = 0
	elif !coldown:
		magazine += magazineSize

func on_timeout_complete():
	coldown = false
