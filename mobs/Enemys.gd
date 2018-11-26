extends RigidBody2D

var root_scene = null
var player = null
var block_spawn = null
var minimap = null
var timer = null

#var mobs = { triangle = { image = load("res://images/triangleMob2.png") }, square = { image = load("res://images/squareMob2.png") }, hexagon = { image = load("res://images/hexagonMob2.png") } }
var mob_type 

var id = 0
var _name = ""
var block_id = 0
var status = "passive"

var life = true
var hp = 100
var maxSpeed = 0

var hit = false
var hitColdown = 0.1

var attack = false
var attackColdown = 1

var target = null

var explosive = { triangle = preload("res://parts/explosive0.tscn"), square = preload("res://parts/explosive1.tscn"), hexagon = preload("res://parts/explosive2.tscn") }

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

func _physics_process(delta):
	AI(delta)
	if hp <= 0:
		die()
	if map.lvlStep == 1:
		die()

func on_hit():
	var hit_color = get_node("hit_color")
	if hit:
		hit_color.visible = true
		timer.set_wait_time(hitColdown)
		timer.start()
	else:
		hit_color.visible = false

func die():
	if _name == "Triangle":
		player.score += 1
		var e = explosive.triangle.instance()
		e.position = global_position
		root_scene.add_child(e)
	elif _name == "Square":
		player.score += 2
		var e = explosive.square.instance()
		e.position = global_position
		root_scene.add_child(e)
	elif _name == "Hexagon":
		player.score += 4
		var e = explosive.hexagon.instance()
		e.position = global_position
		root_scene.add_child(e)
	if map.lvlStep == 0:
		add_block()
	queue_free()
	#minimap.miniMas[id].queue_free()
	map.living_enemy -= 1

func add_block():
	block_spawn.create_block(block_id)

func AI(delta):
	findTarget()
	move_to_target(delta)

func findTarget(): 
	for i in root_scene.get_children().size():
		if target == null:
			if root_scene.get_child(i).is_in_group("player"):
				var ad = global_position
				var dist = ad.distance_to(root_scene.get_child(i).global_position)
				if(dist < 960):
					target = root_scene.get_child(i)
			#elif root_scene.get_child(i).is_in_group("block"):
				#target = root_scene.get_child(i)

func checkdist():
	if target == player:
		var ad = global_position
		var dist = ad.distance_to(target.global_position)
		if _name == "Triangle" or _name == "Square":
			if dist < 960:
				status = "agressive"
				if dist <= 64:
					status = "fight"
					attack()
			elif dist >= 960:
				if(!target != null):
					target = null
					status = "passive"
					findTarget()
		elif _name == "Hexagon":
			if dist < 1000:
				status = "agressive"
				if dist <= 512:
					status = "fight"
					self.blast_shoot(target)
			elif dist >= 1000:
				if(!target != null):
					target = null
					status = "passive"
					findTarget()

func move_to_target(delta):
	if target != null:
		checkdist()
		var t = target.global_position
		var s = self.global_position
		var dist = { x = t.x - s.x, y = t.y - s.y }
		var velocity = Vector2(dist.x, dist.y)
		if velocity.x > maxSpeed:
			velocity.x = maxSpeed
		elif velocity.y > maxSpeed:
			velocity.y = maxSpeed
		linear_velocity += Vector2(velocity.x*delta, velocity.y*delta)

func attack():
	if !attack and !target.invulnerability:
		target.on_hit()
		attack = true
		target.hp -= 5
		target.set_collision_mask(1)
		target.set_collision_layer(1)
		timer.set_wait_time(attackColdown)
		timer.start()

func _on_Body2D_body_entered(body):
	if body.is_in_group("bullet"):
		body.queue_free()
		hit = true
		if !self.is_in_group("boss"):
			on_hit()
		hp -= body.damage

func _on_Timer_timeout():
	if hit:
		hit = false
		on_hit()
	if attack:
		target.set_collision_mask(1+8)
		target.set_collision_layer(1+8)
		attack = false